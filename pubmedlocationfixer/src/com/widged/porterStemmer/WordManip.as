/*
  Copyright (c) 2009 Marielle Lange (mlange@widged.com)
  
  This file content is licensed under the MIT License

  Permission is hereby granted, free of charge, to any person obtaining 
  a copy of this software and associated documentation files (the
  Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
package com.widged.porterStemmer
{
 /**
  * A class with utility functions for word manipulation and word transformation.
  * All methods are static. 
  */
   public class WordManip
   {

      /*  ############################
         Final Letters
      ############################## */

      public static function hasFinalLetters(word:String, letters:String):Boolean 
      {
         // the ending is longer than the word
         if(letters.length >= word.length) 
            return false

         // extract characters from right of str
         var qty:uint = letters.length
         if(getFinalLetters(word, qty) == getFinalLetters(letters, qty)) 
            return true
         else
            return false
      }

      public static function getFinalLetters(word:String, qty:uint):String 
      {
         if(0 == qty)
            return ""
         return word.substr(word.length - qty, qty)
      }
      
      public static function removeFinalLetters(word:String, qty:uint):String 
      {
         if(0 == qty)
            return ""
         return word.substr(0, word.length - qty)
      }
      
      public static function addFinalLetters(word:String, letters:String):String 
      {
         return word + letters
       
      }
      
      /*  ############################
         Vowel and Consonants
      ############################## */

      public static function hasVowel(str:String):Boolean 
      {
         if(0 == str.length)
            return false
            
         var pattern:String =  wordCvcPattern(str) 
         if(pattern.indexOf("v") > -1) 
            return true
         return false
      }
      
      public static function hasFinalDoubleConsonants(str:String):Boolean 
      {
          
         if(2 > str.length) 
            return false

         var wordPattern:String = wordCvcPattern(str) 
         if("c" != wordPattern.substr(str.length - 1) )
            return false
         var lastLetter:String = str.substr(str.length - 1)
         var penultLetter:String =  str.substr(str.length - 2)
         if(lastLetter == penultLetter)
            return true
         return false
      }
      
      public static function countFinalConsonants(str:String):Number 
      {
         var count:Number = 0
         
         if(0 == str.length) 
            return 0
            
         var wordPattern:String = wordCvcPattern(str)  
         var lastIdx:uint = str.length - 1
         for (var i:Number = lastIdx; i >= 0; i--) {
            if("v" == wordPattern.substr(i, 1))
               break
            count++
         }
         return  count
        }
      
      public static function isVowel(str:String):Boolean {
         var vowels:String = ".a.e.i.o.u."
         if(vowels.indexOf("." + str + ".") > -1) 
            return true
         return false
      }
      
      /*
          A \consonant\ in a word is a letter other than A, E, I, O or U, and other
          than Y preceded by a consonant. (The fact that the term `consonant' is
          defined to some extent in terms of itself does not make it ambiguous.) So in
          TOY the consonants are T and Y, and in SYZYGY they are S, Z and G. If a
          letter is not a consonant it is a \vowel\.
       */    
             public static function wordCvcPattern(str:String):String {
         // returned
         var pattern:String = ""

         // checking each character to see if it is a consonant or a vowel. 
         // also inputs the information in const_vowel
         for (var i:int = 0; i < str.length; i++) {
            var vc:String = "."
            var letter:String = str.substr(i, 1) 
            if(isVowel(letter))
               vc = "v"
            else if (letter == "y") {
               if(0  == i) 
                  vc = "c"
                else if (isVowel(str.substr(i-1, 1)))
                  vc = "v"
                else 
                  vc = "c"
            } 
            else
            {
               vc = "c"
            }
            pattern += vc
         }
         
         return pattern
      }
      
      public static function hasCvcFinalLetters(str:String):Boolean {
      // *o  - the stem ends cvc, where the second c is not 
      //       W, X or Y (e.g. -WIL, -HOP).
      
         if(str.length < 3) 
            return false
            
         var pattern:String = wordCvcPattern(str)
         var trio:String = getFinalLetters(pattern, 3)   
            
         if("cvc" != trio) 
            return false
         
         var lastLetter:String = str.substr(str.length - 1, 1)
         var avoid:String = ".w.x.y."
         if(avoid.indexOf(lastLetter) < 0)
            return true
         
         return false
      }
      
      /*  ############################
         Syllables
      ############################## */

      public static function countSyllables(str:String):Number {
         var pattern:String = wordCvcPattern(str)
         var flag:Boolean = false
         var count:Number = 0
         for (var i:uint =0; i < pattern.length; i++) 
         {
            var cv:String = pattern.substr(i, 1)
           if(cv == "v" || flag) 
           {
              flag = true
              if(cv == "c") 
              {
                 count++
                 flag = false
              }
            }
         }
         return count
      }
       
   }
}