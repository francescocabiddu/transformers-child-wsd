import re
import logging
from transformers import set_seed, OpenAIGPTTokenizer, OpenAIGPTModel, OpenAIGPTConfig, AutoConfig

import mkl
mkl.set_dynamic(0)
mkl.set_num_threads(6)

import torch as th
import numpy as np

from transformers import BertModel, BertTokenizer, RobertaModel, RobertaTokenizerFast, RobertaForMaskedLM, DebertaModel, \
    DebertaTokenizer, DebertaV2Tokenizer, DebertaV2Model, GPT2Model, GPT2Tokenizer, AutoModel, AutoTokenizer, \
    TransfoXLTokenizer, TransfoXLModel, XLNetModel, XLNetTokenizer, CTRLTokenizer, CTRLModel, T5Tokenizer, \
    AlbertModel, AlbertTokenizer, T5EncoderModel, DistilBertTokenizer, DistilBertModel, AutoModelForMaskedLM, \
    AutoModelForCausalLM, BertConfig, DistilBertConfig, RobertaConfig, AlbertConfig, DebertaV2Config, DebertaConfig, \
    GPT2Config, TransfoXLConfig, XLNetConfig, CTRLConfig, T5Config

import tensorflow_hub as hub
import tensorflow as tf


class TransformerEncoder():

    def __init__(self, nlm_config):
        self.nlm_config = nlm_config
        self.nlm_model = None
        self.nlm_tokenizer = None
        self.special_ids = None

        self.load_nlm(nlm_config['model_name_or_path'],
                      nlm_config['random_init'],
                      nlm_config['seed'])

    def load_nlm(self, model_name_or_path, random_init, seed):
        set_seed(seed)

        if model_name_or_path.startswith('bert-'):
            self.nlm_tokenizer = BertTokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [1, -1]

            if random_init == False:
                self.nlm_model = BertModel.from_pretrained(model_name_or_path, output_hidden_states=True)
            else:
                config = BertConfig.from_pretrained('bert-base-uncased', output_hidden_states = True)
                self.nlm_model = BertModel(config)

        elif model_name_or_path.startswith('distilbert-'):
            self.nlm_tokenizer = DistilBertTokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [1, -1]

            if random_init == False:
                self.nlm_model = DistilBertModel.from_pretrained(model_name_or_path, output_hidden_states=True)
            else:
                config = DistilBertConfig.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = DistilBertModel(config)

        elif model_name_or_path.startswith('distilroberta-'):
            self.nlm_model = AutoModelForMaskedLM.from_pretrained(model_name_or_path, output_hidden_states=True)
            self.nlm_tokenizer = AutoTokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [1, -1]

        elif model_name_or_path.startswith('distilgpt2'):
            self.nlm_model = AutoModelForCausalLM.from_pretrained(model_name_or_path, output_hidden_states=True)
            self.nlm_tokenizer = AutoTokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [None, None]

        elif model_name_or_path.startswith('roberta-'):
            self.nlm_tokenizer = RobertaTokenizerFast.from_pretrained(model_name_or_path)
            self.special_ids = [1, -1]

            if random_init == False:
                self.nlm_model = RobertaModel.from_pretrained(model_name_or_path,output_hidden_states=True)
            else:
                config = RobertaConfig.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = RobertaModel(config)

        elif model_name_or_path.startswith('albert-'):
            self.nlm_tokenizer = AlbertTokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [1, -1]

            if random_init == False:
                self.nlm_model = AlbertModel.from_pretrained(model_name_or_path,output_hidden_states=True)
            else:
                config = AlbertConfig.from_pretrained(model_name_or_path,output_hidden_states=True)
                self.nlm_model = AlbertModel(config)

        elif model_name_or_path.startswith('nyu-mll/'): # RoBERTa at different input size 1M to 1B tokens
            self.nlm_model = AutoModel.from_pretrained(model_name_or_path, output_hidden_states=True)
            self.nlm_tokenizer = AutoTokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [1, -1]

        elif 'BabyBERTa' in model_name_or_path:
            self.nlm_tokenizer = RobertaTokenizerFast.from_pretrained('saved_babyberta_models/' + model_name_or_path,
                                                                 add_prefix_space=True)
            self.nlm_model = RobertaForMaskedLM.from_pretrained('saved_babyberta_models/' + model_name_or_path, output_hidden_states=True)
            self.special_ids = [1, -1]

        elif 'deberta-v3' in model_name_or_path:
            #self.nlm_tokenizer = AutoTokenizer.from_pretrained(model_name_or_path)
            self.nlm_tokenizer = DebertaV2Tokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [1, -1]

            if random_init == False:
                #self.nlm_model = AutoModel.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = DebertaV2Model.from_pretrained(model_name_or_path, output_hidden_states=True)
            else:
                #config = AutoConfig.from_pretrained(model_name_or_path, output_hidden_states=True)
                #self.nlm_model = AutoModel(config)
                config = DebertaV2Config.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = DebertaV2Model(config)

        elif 'deberta-v2' in model_name_or_path:
            self.nlm_tokenizer = DebertaV2Tokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [1, -1]

            if random_init == False:
                self.nlm_model = DebertaV2Model.from_pretrained(model_name_or_path, output_hidden_states=True)
            else:
                config = DebertaV2Config.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = DebertaV2Model(config)

        elif 'deberta-' in model_name_or_path:
            self.nlm_tokenizer = DebertaTokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [1, -1]

            if random_init == False:
                self.nlm_model = DebertaModel.from_pretrained(model_name_or_path, output_hidden_states=True)
            else:
                config = DebertaConfig.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = DebertaModel(config)

        elif 'gpt2' in model_name_or_path:
            self.nlm_tokenizer = GPT2Tokenizer.from_pretrained(model_name_or_path, pad_token = '[PAD]')
            self.special_ids = [None, None]

            if random_init == False:
                self.nlm_model = GPT2Model.from_pretrained(model_name_or_path, output_hidden_states=True)
            else:
                config = GPT2Config.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = GPT2Model(config)

        elif 'openai-gpt' in model_name_or_path:
            self.nlm_tokenizer = OpenAIGPTTokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [None, None]

            if random_init == False:
                self.nlm_model = OpenAIGPTModel.from_pretrained(model_name_or_path, output_hidden_states=True)
            else:
                config = OpenAIGPTConfig.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = OpenAIGPTModel(config)

        elif 'transfo-xl' in model_name_or_path:
            self.nlm_tokenizer = TransfoXLTokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [None, None]

            if random_init == False:
                self.nlm_model = TransfoXLModel.from_pretrained(model_name_or_path, output_hidden_states=True)
            else:
                config = TransfoXLConfig.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = TransfoXLModel(config)

        elif 'xlnet' in model_name_or_path:
            self.nlm_tokenizer = XLNetTokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [0, -2]

            if random_init == False:
                self.nlm_model = XLNetModel.from_pretrained(model_name_or_path, output_hidden_states=True)
            else:
                config = XLNetConfig.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = XLNetModel(config)

        elif 'ctrl' in model_name_or_path:
            self.nlm_tokenizer = CTRLTokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [None, None]

            if random_init == False:
                self.nlm_model = CTRLModel.from_pretrained(model_name_or_path, output_hidden_states=True)
            else:
                config = CTRLConfig.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = CTRLModel(config)

        elif 't5' in model_name_or_path:
            self.nlm_tokenizer = T5Tokenizer.from_pretrained(model_name_or_path)
            self.special_ids = [0, -1]

            if random_init == False:
                self.nlm_model = T5EncoderModel.from_pretrained(model_name_or_path, output_hidden_states=True)
            else:
                config = T5Config.from_pretrained(model_name_or_path, output_hidden_states=True)
                self.nlm_model = T5EncoderModel(config)

        elif 'elmo' in model_name_or_path:
            self.nlm_model = hub.load("https://tfhub.dev/google/elmo/3")

        else:
            raise(BaseException('Invalid model_name - %s' % model_name_or_path))

        if model_name_or_path != 'elmo':
            self.nlm_model.eval()
            self.nlm_model.to('cuda')

    def get_encodings(self, sentence):
        """
        sentence: e.g., ["By-word", "sentence"]
        nlm_tokenizer: loaded tokenizer from pretrained
        special_ids: exclude special tokens by position e.g. ["By-word", "sentence", "<sep>", "<cls>"][None:-2]
        OUTPUT: tokenized sentence by word (special tokens are not considered)
        """
        complete_sentence = self.nlm_tokenizer(" ".join(sentence), add_special_tokens=True, padding=False, return_attention_mask=True)

        list_word_encodings = []

        for word_id in range(len(sentence)):
            if word_id == 0:
                word_temp = self.nlm_tokenizer(sentence[word_id], add_special_tokens=False, padding=False, return_attention_mask=False)
                list_word_encodings.append(word_temp['input_ids'])
            else:
                word_temp = self.nlm_tokenizer(" ".join(["", sentence[word_id]]), add_special_tokens=False, padding=False, return_attention_mask=False)
                list_word_encodings.append(word_temp['input_ids'])

        if sorted(sum(list_word_encodings, [])) != sorted(complete_sentence['input_ids'][self.special_ids[0]:self.special_ids[1]]):
            print(sentence)
            print(list_word_encodings)
            print(sum(list_word_encodings, []))
            print(complete_sentence['input_ids'][self.special_ids[0]:self.special_ids[1]])
            print(sorted(sum(list_word_encodings, [])) != sorted(complete_sentence['input_ids'][self.special_ids[0]:self.special_ids[1]]))
            print(sorted(sum(list_word_encodings, [])))
            print(sorted(complete_sentence['input_ids'][self.special_ids[0]:self.special_ids[1]]))
            logging.fatal('ERROR: Tokens by word do not match raw tokenized sentence.\nDid you specify the correct special_ids?')
            return

        return [list_word_encodings]

    def merge_subword_embeddings(self, tokens, encodings, embeddings, return_tokens=True):
        # align and merge subword embeddings
        tok_embeddings = []
        encoding_idx = 0
        for tok, tok_encodings in zip(tokens, encodings):

            if self.nlm_config['subword_op'] == 'mean':
                tok_embedding = th.zeros(embeddings.shape[-1]).to('cuda')
                for _ in tok_encodings:
                    tok_embedding += embeddings[encoding_idx]
                    encoding_idx += 1
                tok_embedding = tok_embedding / len(tok_encodings)  # avg of subword embs

            elif self.nlm_config['subword_op'] == 'first':
                tok_embedding = embeddings[encoding_idx]
                for _ in tok_encodings:
                    encoding_idx += 1  # just move idx

            else:
                raise(BaseException('Invalid subword_op - %s' % self.nlm_config['subword_op']))

            tok_embedding = tok_embedding.detach().cpu().numpy()

            if return_tokens:
                tok_embeddings.append((tok, tok_embedding))
            else:
                tok_embeddings.append(tok_embedding)

        return tok_embeddings

    def get_num_features(self, batch_sent_tokens):
        inst = self.nlm_tokenizer(" ".join(batch_sent_tokens), add_special_tokens=True, padding=False)

        return len(inst['input_ids'])

    def get_num_subtokens(self, tokens):
        return len(self.get_encodings(tokens))


    def get_token_embeddings_batch(self, batch_sent_tokens, return_tokens=True):

        batch_sent_encodings = self.get_encodings(batch_sent_tokens)

        inst = self.nlm_tokenizer(" ".join(batch_sent_tokens), add_special_tokens=True, padding=False, return_attention_mask=True)

        input_ids = th.tensor([inst['input_ids']]).to('cuda')
        input_mask = th.tensor([inst['attention_mask']]).to('cuda')
        
        
        with th.no_grad():

            if 'transfo-xl' in self.nlm_config['model_name_or_path']:
                batch_hidden_states = self.nlm_model(input_ids)['hidden_states']

            else:
                # MODIFIED to be compatible with later versions of transformers
                batch_hidden_states = self.nlm_model(input_ids, attention_mask=input_mask)['hidden_states']


        # select layers of interest
        sel_hidden_states = [batch_hidden_states[i] for i in self.nlm_config['layers']]

        # merge subword embeddings
        merged_batch_hidden_states = []
        for layer_hidden_states in sel_hidden_states:
            merged_layer_hidden_states = []
            for sent_idx, sent_embeddings in enumerate(layer_hidden_states):
                sent_embeddings = sent_embeddings[self.special_ids[0]:self.special_ids[1]]  # ignoring special tokens

                sent_tokens = [batch_sent_tokens][sent_idx]
                sent_encodings = batch_sent_encodings[sent_idx]

                sent_embeddings = self.merge_subword_embeddings(sent_tokens, sent_encodings,
                                                                sent_embeddings, return_tokens=return_tokens)
                merged_layer_hidden_states.append(sent_embeddings)
            merged_batch_hidden_states.append(merged_layer_hidden_states)

        # combine layers
        combined_batch_embeddings = []
        for sent_idx, sent_tokens in enumerate([batch_sent_tokens]):

            combined_sent_embeddings = []
            for tok_idx in range(len(sent_tokens)):
                tok_layer_vecs = []
                for layer_idx in range(len(merged_batch_hidden_states)):
                    tok_layer_vecs.append(merged_batch_hidden_states[layer_idx][sent_idx][tok_idx][1])

                if len(tok_layer_vecs) == 1:
                    tok_combined_vec = tok_layer_vecs[0]
                
                else:
                    tok_layer_vecs = np.array(tok_layer_vecs)

                    if self.nlm_config['layer_op'] == 'sum':
                        tok_combined_vec = tok_layer_vecs.sum(axis=0)

                tok = merged_batch_hidden_states[layer_idx][sent_idx][tok_idx][0]
                combined_sent_embeddings.append((tok, tok_combined_vec))
            
            combined_batch_embeddings.append(combined_sent_embeddings)

        return [combined_batch_embeddings]


    def token_embeddings(self, batch_sent_tokens, return_tokens=True):
        if  self.nlm_config['model_name_or_path'] != 'elmo':
            return self.get_token_embeddings_batch(batch_sent_tokens, return_tokens=return_tokens)
        else:
            batch_sent_tokens_split = batch_sent_tokens[0]
            batch_sent_tokens = [" ".join(batch_sent_tokens[0])]
            embeddings = self.nlm_model.signatures["default"](tf.constant(batch_sent_tokens))

            inst_vecs_elmo = []
            for i in range(len(batch_sent_tokens_split)):
                inst_vecs_elmo.append(
                    (batch_sent_tokens_split[i],embeddings['elmo'].numpy()[0][i])
                )

            return inst_vecs_elmo

if __name__ == '__main__':

#    encoder_cfg = {
#        'model_name_or_path': 'microsoft/deberta-base',
#        'weights_path': '',
#        'min_seq_len': 0,
#        'max_seq_len': 512,
#        'layers': [-1, -2, -3, -4],
#        'layer_op': 'sum',
#        'subword_op': 'mean'
#    }
#
#    enc = TransformerEncoder(encoder_cfg)
#
    tokenized_sents = [['Hello', 'world', '!'], ['Bye', 'now', ',', 'see', 'you', 'later', '?']]
#
#    embs = enc.get_token_embeddings_batch(tokenized_sents)
