/***********************************************************************
* File       : <spell_checker.c>
*
* Author     : <Siavash Katebzadeh>
*
* Description: 
*
* Date       : 08/10/18
*
***********************************************************************/
// ==========================================================================
// Spell checker 
// ==========================================================================
// Marks misspelled words in a sentence according to a dictionary

// Inf2C-CS Coursework 1. Task B/C 
// PROVIDED file, to be used as a skeleton.

// Instructor: Boris Grot
// TA: Siavash Katebzadeh
// 08 Oct 2018

#include <stdio.h>

// maximum size of input file
#define MAX_INPUT_SIZE 2048
// maximum number of words in dictionary file
#define MAX_DICTIONARY_WORDS 10000
// maximum size of each word in the dictionary
#define MAX_WORD_SIZE 20

int read_char() { return getchar(); }
int read_int()
{
    int i;
    scanf("%i", &i);
    return i;
}
void read_string(char* s, int size) { fgets(s, size, stdin); }

void print_char(int c)     { putchar(c); }   
void print_int(int i)      { printf("%i", i); }
void print_string(char* s) { printf("%s", s); }
void output(char *string)  { print_string(string); }

// dictionary file name
char dictionary_file_name[] = "dictionary.txt";
// input file name
char input_file_name[] = "input.txt";
// content of input file
char content[MAX_INPUT_SIZE + 1];
// valid punctuation marks
char punctuations[] = ",.!?";
// tokens of input file
char tokens[MAX_INPUT_SIZE + 1][MAX_INPUT_SIZE + 1];
// number of tokens in input file
int tokens_number = 0;
// content of dictionary file
char dictionary[MAX_DICTIONARY_WORDS * MAX_WORD_SIZE + 1];

///////////////////////////////////////////////////////////////////////////////
/////////////// Do not modify anything above
///////////////////////////////////////////////////////////////////////////////

// You can define your global variables here!
char MYDICTIONARY[MAX_DICTIONARY_WORDS + 1][MAX_WORD_SIZE + 1];
int DICTIONARY_SIZE=0;


int toLower(int c)
{
    return (c>='A' && c<='Z') ? (c + 32) : (c);    
}

int strEqual(char *str1, char *str2){
  int i;
  while(1){
    if(toLower(str1[i])!=str2[i])
      return 0;
    if(str1[i]=='\0')
      return 1;
    i++;
  }
}

// Task B
void spell_checker() {

  // this first part load the whole dictionary into 2D array of each of chars which make it an array of strings
  int i=0, j=0; 
  do{
  int k=0;
    do{
      MYDICTIONARY[j][k]=dictionary[i];
      k++;
      i++;

  } while(dictionary[i]!='\n'); 
  MYDICTIONARY[j][k]='\0';
  DICTIONARY_SIZE++;
  i++;
  j++;
}while(dictionary[i]!='\0');
  

// while the dictionary and tokens are in same format -2d array- with if every string in token is in dictionary
  int flag=0;
  for(i=0;i<tokens_number;i++){
    for(j=0;j<=DICTIONARY_SIZE;j++){
      // printf(" %s %s",tokens[i],MYDICTIONARY[j]);
      int a=0;
      // this while is to compare if two strings are the same if not flag 0 and print it with _'s
      while(1){

        if(toLower(*(tokens[i]+a)) != *(MYDICTIONARY[j]+a))
          break;
        if(tokens[i][a]=='\0'){
          flag=1;
          break;
        }
        a++;
      }
      if(flag==1){
        break;
      }

    }
    if(flag==0 && tokens[i][0]>=65){

      printf("_%s_",tokens[i]);
    }else{
      printf("%s",tokens[i]);
    }
    flag=0;
    
  }

  return;
}



//---------------------------------------------------------------------------
// Tokenizer function
// Split content into tokens
//---------------------------------------------------------------------------
void tokenizer(){
  char c;

  // index of content
  int c_idx = 0;
  c = content[c_idx];
  do {

    // end of content
    if(c == '\0'){
      break;
    }

    // if the token starts with an alphabetic character
    if((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {

      int token_c_idx = 0;
      // copy till see any non-alphabetic character
      do {
        tokens[tokens_number][token_c_idx] = c;

        token_c_idx += 1;
        c_idx += 1;

        c = content[c_idx];
      } while((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'));
      tokens[tokens_number][token_c_idx] = '\0';
      tokens_number += 1;

      // if the token starts with one of punctuation marks
    } else if((c == ',') || (c == '.') || (c == '!') || (c == '?')) {

      int token_c_idx = 0;
      // copy till see any non-punctuation mark character
      do {
        tokens[tokens_number][token_c_idx] = c;

        token_c_idx += 1;
        c_idx += 1;

        c = content[c_idx];
      } while((c == ',') || (c == '.') || (c == '!') || (c == '?'));
      tokens[tokens_number][token_c_idx] = '\0';
      tokens_number += 1;

      // if the token starts with space
    } else if(c == ' ') {

      int token_c_idx = 0;
      // copy till see any non-space character
      do {
        tokens[tokens_number][token_c_idx] = c;

        token_c_idx += 1;
        c_idx += 1;

        c = content[c_idx];
      } while(c == ' ');
      tokens[tokens_number][token_c_idx] = '\0';
      tokens_number += 1;
    }
  } while(1);
}
//---------------------------------------------------------------------------
// MAIN function
//---------------------------------------------------------------------------

int main (void)
{


  /////////////Reading dictionary and input files//////////////
  ///////////////Please DO NOT touch this part/////////////////
  int c_input;
  int idx = 0;
  
  // open input file 
  FILE *input_file = fopen(input_file_name, "r");
  // open dictionary file
  FILE *dictionary_file = fopen(dictionary_file_name, "r");

  // if opening the input file failed
  if(input_file == NULL){
    print_string("Error in opening input file.\n");
    return -1;
  }

  // if opening the dictionary file failed
  if(dictionary_file == NULL){
    print_string("Error in opening dictionary file.\n");
    return -1;
  }

  // reading the input file
  do {
    c_input = fgetc(input_file);
    // indicates the the of file
    if(feof(input_file)) {
      content[idx] = '\0';
      break;
    }
    
    content[idx] = c_input;

    if(c_input == '\n'){
      content[idx] = '\0'; 
    }

    idx += 1;

  } while (1);

  // closing the input file
  fclose(input_file);

  idx = 0;

  // reading the dictionary file
  do {
    c_input = fgetc(dictionary_file);
    // indicates the end of file
    if(feof(dictionary_file)) {
      dictionary[idx] = '\0';
      break;
    }
    
    dictionary[idx] = c_input;
    idx += 1;
  } while (1);

  // closing the dictionary file
  fclose(dictionary_file);
  //////////////////////////End of reading////////////////////////
  ////////////////////////////////////////////////////////////////

  tokenizer();
  
  spell_checker();

  return 0;
}
