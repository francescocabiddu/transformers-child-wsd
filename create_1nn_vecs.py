import shutil

import re

import logging
import argparse
import os
import winsound
from time import time
import torch as th

import json
import numpy as np

from nlm_encoder2 import TransformerEncoder

from coarsewsd20_reader import load_instances
from coarsewsd20_reader import ambiguous_words


logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s',
                    datefmt='%d-%b-%y %H:%M:%S')


def create_vecs(args):
    sense_vecs = {}
    n_sents = 0

    for word in ambiguous_words:
        logging.info('Processing \'%s\' ...' % word)

        for inst_idx, inst in enumerate(load_instances(word, split='train', setname=args.dataset_id,
                                                       random_inst = args.random_inst, inst_n = args.inst_n, seed_inst = args.seed)):
            n_sents += 1

            if args.nlm_id != 'elmo':
                if encoder.get_num_subtokens(inst['tokens']) >= args.max_seq_len:
                    logging.error('%s:%d exceeds max_seq_len (%d).' % (word, inst_idx, args.max_seq_len))
                    continue

                try:
                    inst_vecs = encoder.token_embeddings(inst['tokens'])[0][0]
                except:
                    logging.info('ERROR: %s:%d' % (word, inst_idx + 1))
                    continue
            else:
                try:
                    inst_vecs = encoder.token_embeddings([inst['tokens']])
                except:
                    logging.info('ERROR: %s:%d' % (word, inst_idx + 1))
                    continue

            # CODE CHANGED HERE TO ACCOUNT FOR PLURALS
            #assert inst_vecs[inst['idx']][0] == word  # sanity check
            if word == 'glasses':
                assert inst_vecs[inst['idx']][0] in word
            else:
                assert word in inst_vecs[inst['idx']][0]

            word_vec = inst_vecs[inst['idx']][1]
            word_cls = inst['class']

            try:
                sense_vecs[word_cls]['vecs_sum'] += word_vec
                sense_vecs[word_cls]['vecs_num'] += 1
            except KeyError:
                sense_vecs[word_cls] = {'vecs_sum': word_vec, 'vecs_num': 1}

    logging.info('Writing Sense Vectors to %s ...' % args.out_path)
    with open(args.out_path, 'w') as vecs_f:
        for sense, vecs_info in sense_vecs.items():
            vec = vecs_info['vecs_sum'] / vecs_info['vecs_num']
            vec_str = ' '.join([str(round(v, 6)) for v in vec.tolist()])            
            vecs_f.write('%s %s\n' % (sense, vec_str))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Create Initial Sense Embeddings.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-nlm_id', type = str, help='HF Transfomers model name', required=False, default=" ")
    parser.add_argument('-random_init', type = str, help='Randomly initialised model', required=False, default="False")
    parser.add_argument('-random_inst', type = str, help='Random sample of input sentences', required=False, default="False")
    parser.add_argument('-seed', type = int, help='set seed', required=False, default=199)
    parser.add_argument('-inst_n', type = int, help='number of random sentences', required=False, default=40)
    parser.add_argument('-dataset_id', help='Dataset name', required=False, default='ChiSense-12_for_nlm')
    parser.add_argument('-max_seq_len', type=int, default=512, help='Maximum sequence length (BERT)', required=False)
    parser.add_argument('-subword_op', type=str, default='mean', help='WordPiece Reconstruction Strategy', required=False,
                        choices=['mean', 'first', 'sum'])
    parser.add_argument('-layers', type=str, default='-1 -2 -3 -4', help='Relevant NLM layers', required=False)
    parser.add_argument('-layer_op', type=str, default='sum', help='Operation to combine layers', required=False,
                        choices=['mean', 'first', 'sum'])
    parser.add_argument('-out_path', help='Path to resulting vector set', required=False,
                        default=" ")
    args = parser.parse_args()

    if args.random_init == "True":
        args.random_init = True
    else:
        args.random_init = False

    if args.random_inst == "True":
        args.random_inst = True
    else:
        args.random_inst = False

    args.layers = [int(n) for n in args.layers.split(' ')]

    model_names = args.nlm_id.split(' ')
    for model_name in model_names:
        args.nlm_id = model_name
        if '/' in model_name:
            model_name = re.sub(r"^.*/", "", model_name)

        args.out_path = 'vectors/' + args.dataset_id + '.' + model_name + '.txt'

        if args.random_init == True:
            for random_seed in range(1, 11):
                args.seed = random_seed
                args.out_path = re.sub(r"\.txt$", "", args.out_path)
                args.out_path = args.out_path + "_random" + str(random_seed) + ".txt"

                encoder_cfg = {
                    'model_name_or_path': args.nlm_id,
                    'seed': args.seed,
                    'random_init': args.random_init,
                    'random_inst': args.random_inst,
                    'inst_n': args.inst_n,
                    'min_seq_len': 0,
                    'max_seq_len': args.max_seq_len,
                    'layers': args.layers,
                    'layer_op': 'sum',
                    'subword_op': 'mean'
                }

                logging.info('Loading NLM ...')
                encoder = TransformerEncoder(encoder_cfg)
                create_vecs(args)
                args.out_path = re.sub(r"_random\d+\.txt$", "", args.out_path)
                del encoder
                th.cuda.empty_cache()

        elif args.random_inst == True:
            for random_seed in range(1, 11):
                args.seed = random_seed
                args.out_path = re.sub(r"\.txt$", "", args.out_path)
                args.out_path = args.out_path + "_downsample" + str(random_seed) + ".txt"

                encoder_cfg = {
                    'model_name_or_path': args.nlm_id,
                    'seed': args.seed,
                    'random_init': args.random_init,
                    'random_inst': args.random_inst,
                    'inst_n': args.inst_n,
                    'min_seq_len': 0,
                    'max_seq_len': args.max_seq_len,
                    'layers': args.layers,
                    'layer_op': 'sum',
                    'subword_op': 'mean'
                }

                logging.info('Loading NLM ...')
                encoder = TransformerEncoder(encoder_cfg)
                create_vecs(args)
                args.out_path = re.sub(r"_downsample\d+\.txt$", "", args.out_path)
                del encoder
                th.cuda.empty_cache()
        else:
            encoder_cfg = {
                'model_name_or_path': args.nlm_id,
                'seed': args.seed,
                'random_init': args.random_init,
                'random_inst': args.random_inst,
                'inst_n': args.inst_n,
                'min_seq_len': 0,
                'max_seq_len': args.max_seq_len,
                'layers': args.layers,
                'layer_op': 'sum',
                'subword_op': 'mean'
            }

            logging.info('Loading NLM ...')
            encoder = TransformerEncoder(encoder_cfg)
            create_vecs(args)
            del encoder
            th.cuda.empty_cache()

        if 'elmo' in args.nlm_id:
            # USE YOUR ELMO PATH HERE
            shutil.rmtree('C:\\Users\\cabid\\AppData\\Local\\Temp\\tfhub_modules\\58051eb9ff2f7c649b7c541acc518dac54e786ca')
        elif 'BabyBERTa' not in args.nlm_id:
            shutil.rmtree('C:\\Users\\cabid\\.cache\\huggingface\\hub')

    duration = 600  # milliseconds
    freq = 440  # Hz
    winsound.Beep(freq, duration)
    winsound.Beep(freq, duration)

