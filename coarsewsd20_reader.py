import json
from collections import defaultdict
import random

def load_coarse_senses():
    senses = defaultdict(list)
    with open('data/senses.tsv') as senses_f:
        for line in senses_f:
            amb_word, sense = line.strip().split('\t')
            senses[amb_word].append(sense)
    #print(dict(senses))
    return dict(senses)


coarse_senses = load_coarse_senses()
ambiguous_words = list(coarse_senses.keys())


def get_word_classes(word, setname):

    with open('data/%s/%s/classes_map.txt' % (setname, word)) as classes_json_f:
        word_classes = json.load(classes_json_f)
    
    #print(word_classes)
    return word_classes


def sense2word(sense):
    return sense.split('_')[0]


def get_sk_mappings():
    sk_mappings = {}

    with open('data/wn_mappings.tsv') as f:
        for line_idx, line in enumerate(f):
            if line_idx == 0:
                continue
            word, coarse_sense, syn_offset, syn_name, sk = line.strip().split('\t')
            sk_mappings[sk] = coarse_sense
    
    return sk_mappings


def load_instances(word, split, setname='CoarseWSD-20', mode='regular',
                   random_inst = False, seed_inst = None, inst_n = None):
    instances = []

    # ORIGINAL SCRIPT CHANGED HERE FOR PROBLEMS IN CHARACTER ENCODING
    with open('data/%s/%s/%s.data.txt' % (setname, word, split), encoding = 'UTF-8') as split_data_f:
        for line in split_data_f:
            word_idx, tokens = line.split('\t')
            word_idx = int(word_idx)
            tokens = tokens.split()

            instances.append({'tokens': tokens, 'idx': word_idx, 'class': None})
            
    word_classes = get_word_classes(word, setname)

    # indices reverted here to reflect new positions mapped classes files
    mfs_class = word_classes['1']
    lfs_class = word_classes[sorted(list(word_classes.keys()))[0]]

    with open('data/%s/%s/%s.gold.txt' % (setname, word, split)) as split_gold_f:
        for line_idx, line in enumerate(split_gold_f):
            line_class = line.strip()

            instances[line_idx]['class'] = word_classes[line_class]

    if mode == 'mfs':
        instances = [inst for inst in instances if inst['class'] == mfs_class]
    elif mode == 'lfs':
        instances = [inst for inst in instances if inst['class'] == lfs_class]

    if random_inst == True:
        random.seed(seed_inst)
        mfs_sent = [c for c in instances if c['class'] == mfs_class]
        lfs_sent = [c for c in instances if c['class'] == lfs_class]

        try:
            lfs_subset = random.sample(lfs_sent, k=inst_n)
        except ValueError:
            lfs_subset = random.sample(lfs_sent, k=len(lfs_sent))

        mfs_subset = random.sample(mfs_sent, k=inst_n)
        instances = lfs_subset + mfs_subset

    return instances


def load_instances_ood():
    instances = defaultdict(list)
    
    with open('data/CoarseWSD-20.outofdomain.tsv') as f:
        for line in f:
            word, sense, idx, tokens_str = line.strip().split('\t')
            instances[word].append({'tokens': tokens_str.split(' '), 'idx': int(idx), 'class': sense})

    return instances



if __name__ == '__main__':

    insts = load_instances('mole_10', split='test', setname='nshots/set1', mode='lfs')
    print(len(insts))
