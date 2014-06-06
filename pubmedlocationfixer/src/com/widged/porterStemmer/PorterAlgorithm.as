/*

  Author: Marielle Lange (mlange@widged.com)

   This is an AS3 port of the Porter stemmer suffix dropping algorithm

   It follows the algorithm introduced in:
      Porter, 1980, An algorithm for suffix stripping, Program, Vol. 14,
      no. 3, pp 130-137, (http://www.tartarus.org/~martin/PorterStemmer)

   And follows the steps of the VB version of the algorithm by Navonil Mustafee at
      http://www.tartarus.org/~martin/PorterStemmer/vb.txt
      
   Comments on steps are from original author, with slight modifications
 
*/
package com.widged.porterStemmer
{
   public class PorterAlgorithm
   {
      
      import com.widged.porterStemmer.WordManip

      private var _endList:Array
      private const MORE_THAN_ONE_SYLLABLE_LEFT:String = "moreThanOneSyllableLeft"
      private const MORE_THAN_TWO_SYLLABLE_LEFT:String = "moreThanTwoSyllableLeft"
      private const HAS_VOWEL_LEFT:String = "hasVowelLeft"
      private const FINAL_E_IS_MUTE:String = "endsWithMuteE"
      
      /**
      *  Constructor
      */
      public function PorterAlgorithm()
      {
      }
      
      /**
      *  Read a list of words (stored in an array)
      *  and retrieve the stem for each word in the list
      */
      public function listStem(list:Array):Array 
      {
         // returned
         var arr:Array = []
         var wordQty:uint = list.length

         for (var i:uint = 0; i < wordQty; i++)   
         { 
            var word:String = list[i]
            var stem:String = word
            if(null != word && word.length > 2) 
               stem = wordStem(word)
            if(null != word)
               arr.push(stem)
         }
         return arr
      }

      /**
      *  Retrieve the stem of a given word
      */
      public function wordStem(word:String):String 
      {
         // only strings greater than 2 are stemmed
         if(word.length < 2) {
            return word
         }
         
         // returned
         var str:String = word
         str = step1(str)   
         str = step2(str)   
         str = step3(str)   
         str = step4(str)
         str = step5(str)   
         return str   
      }
      
      
      /*         
         STEP 1A
         
             SSES -> SS                         caresses  ->  caress
             IES  -> I                          ponies    ->  poni
                                                ties      ->  ti
             SS   -> SS                         caress    ->  caress
             S    ->                            cats      ->  cat

        STEP 1B
        
           If
               (m>0) EED -> EE                     feed      ->  feed
                                                   agreed    ->  agree
           Else
               (*v*) ED  ->                        plastered ->  plaster
                                                   bled      ->  bled
               (*v*) ING ->                        motoring  ->  motor
                                                   sing      ->  sing
        
        If the second or third of the rules in Step 1b is successful, the following
        is done:
        
            AT -> ATE                       conflat(ed)  ->  conflate
            BL -> BLE                       troubl(ed)   ->  trouble
            IZ -> IZE                       siz(ed)      ->  size
            (*d and not (*L or *S or *Z))
               -> single letter
                                            hopp(ing)    ->  hop
                                            tann(ed)     ->  tan
                                            fall(ing)    ->  fall
                                            hiss(ing)    ->  hiss
                                            fizz(ed)     ->  fizz
            (m=1 and *o) -> E               fail(ing)    ->  fail
                                            fil(ing)     ->  file
        
        The rule to map to a single letter causes the removal of one of the double
        letter pair. The -E is put back on -AT, -BL and -IZ, so that the suffixes
        -ATE, -BLE and -IZE can be recognised later. This E may be removed in step
        4.
     */
      private function step1(str:String):String {
         
       // Step 1A
      _endList = [
               ["sses", "ss"], 
               ["ies", "i"],
               ["ss", "ss"],
               ["s", ""]
             ]
      str = swapEnds(str)

       // Step 1B

      var second_third_success:Boolean = false
      var match:String
      var replace:String
      var temp:String

      // (m>0) EED -> EE..else..(*v*) ED  ->(*v*) ING  ->
      if(WordManip.hasFinalLetters(str, "eed")) 
      {
         _endList = [["eed", "ee"]]
         temp = swapEnds(str, MORE_THAN_ONE_SYLLABLE_LEFT)
         if(temp != str) { str = temp; second_third_success = true }
      } 
      else if(WordManip.hasFinalLetters(str, match = "ed"))
      {
         _endList = [["ed", ""]]
         temp = swapEnds(str, HAS_VOWEL_LEFT)
         if(temp != str) { str = temp; second_third_success = true }
      } 
      else if(WordManip.hasFinalLetters(str, match = "ing"))
      {
         _endList = [["ing", ""]]
         temp = swapEnds(str, HAS_VOWEL_LEFT)
         if(temp != str) { str = temp; second_third_success = true }
      } 
      
      if(second_third_success) 
      {
         _endList = [
            ["at", "ate"],
            ["bl", "ble"],
            ["iz", "ize"]
           ]
           
         temp = swapEnds(str)
         if(temp != str) 
            str = temp
         else if(WordManip.hasFinalDoubleConsonants(str)) 
         {  // (*d and not (*L or *S or *Z))-> single letter
            var finalLetter:String = WordManip.getFinalLetters(str, 1)
            var avoid:String = ".l.s.z."
            if(avoid.indexOf(finalLetter) < 0)
               str = WordManip.removeFinalLetters(str, 1)
         }
         else if(WordManip.countSyllables(str) == 1) 
         {   // '(m=1 and *o) -> E
            if(WordManip.hasCvcFinalLetters(str))
               str = WordManip.addFinalLetters(str, "e")
         }
      }
/*

   STEP 1C
   
       (*v*) Y -> I                    happy        ->  happi
                                       sky          ->  sky

*/
         
         _endList = [
               ["y", "i"]
             ]
         str = swapEnds(str, HAS_VOWEL_LEFT)
         return str
      }
      
      /*
          STEP 2

          (m>0) ATIONAL ->  ATE           relational     ->  relate
          (m>0) TIONAL  ->  TION          conditional    ->  condition
                                          rational       ->  rational
          (m>0) ENCI    ->  ENCE          valenci        ->  valence
          (m>0) ANCI    ->  ANCE          hesitanci      ->  hesitance
          (m>0) IZER    ->  IZE           digitizer      ->  digitize
      Also,
          (m>0) BLI    ->   BLE           conformabli    ->  conformable
      
          (m>0) ALLI    ->  AL            radicalli      ->  radical
          (m>0) ENTLI   ->  ENT           differentli    ->  different
          (m>0) ELI     ->  E             vileli        - >  vile
          (m>0) OUSLI   ->  OUS           analogousli    ->  analogous
          (m>0) IZATION ->  IZE           vietnamization ->  vietnamize
          (m>0) ATION   ->  ATE           predication    ->  predicate
          (m>0) ATOR    ->  ATE           operator       ->  operate
          (m>0) ALISM   ->  AL            feudalism      ->  feudal
          (m>0) IVENESS ->  IVE           decisiveness   ->  decisive
          (m>0) FULNESS ->  FUL           hopefulness    ->  hopeful
          (m>0) OUSNESS ->  OUS           callousness    ->  callous
          (m>0) ALITI   ->  AL            formaliti      ->  formal
          (m>0) IVITI   ->  IVE           sensitiviti    ->  sensitive
          (m>0) BILITI  ->  BLE           sensibiliti    ->  sensible
      Also,
          (m>0) LOGI    ->  LOG           apologi        -> apolog
      
      The test for the string S1 can be made fast by doing a program switch on
      the penultimate letter of the word being tested. This gives a fairly even
      breakdown of the possible values of the string S1. It will be seen in fact
      that the S1-strings in step 2 are presented here in the alphabetical order
      of their penultimate letter. Similar techniques may be applied in the other
      steps.      
      
      */
      private function step2(str:String):String {
         
         _endList = [
               ["ational", "ate"], 
               ["tional", "tion"],
               ["enci", "ence"],
               ["anci", "ance"],
               ["izer", "ize"],
               ["bli", "ble"],
               ["alli", "al"],
               ["entli", "ent"],
               ["eli", "e"],
               ["ousli", "ous"],
               ["ization", "ize"],
               ["ation", "ate"],
               ["alism", "al"],
               ["iveness", "ive"],
               ["fulness", "ful"],
               ["ousness", "ous"],
               ["aliti", "al"],
               ["iviti", "ive"],
               ["biliti", "ble"],
               ["logi", "log"]
             ]
         return swapEnds(str, MORE_THAN_ONE_SYLLABLE_LEFT)
      }
      
 
      /*
      STEP 3

         (m>0) ICATE ->  IC              triplicate     ->  triplic
         (m>0) ATIVE ->                  formative      ->  form
         (m>0) ALIZE ->  AL              formalize      ->  formal
         (m>0) ICITI ->  IC              electriciti    ->  electric
         (m>0) ICAL  ->  IC              electrical     ->  electric
         (m>0) FUL   ->                  hopeful        ->  hope
         (m>0) NESS  ->                  goodness       ->  good
      */
      private function step3(str:String):String {
         _endList = [
               ["icate", "ic"], 
               ["ative", ""], 
               ["alize", "al"], 
               ["iciti", "ic"], 
               ["ical", "ic"], 
               ["ful", ""], 
               ["ness", ""] 
             ]
         return swapEnds(str, MORE_THAN_ONE_SYLLABLE_LEFT)
      }


      /*
       STEP 4
   
       (m>1) AL    ->                  revival        ->  reviv
       (m>1) ANCE  ->                  allowance      ->  allow
       (m>1) ENCE  ->                  inference      ->  infer
       (m>1) ER    ->                  airliner       ->  airlin
       (m>1) IC    ->                  gyroscopic     ->  gyroscop
       (m>1) ABLE  ->                  adjustable     ->  adjust
       (m>1) IBLE  ->                  defensible     ->  defens
       (m>1) ANT   ->                  irritant       ->  irrit
       (m>1) EMENT ->                  replacement    ->  replac
       (m>1) MENT  ->                  adjustment     ->  adjust
       (m>1) ENT   ->                  dependent      ->  depend
       (m>1 and (*S or *T)) ION ->     adoption       ->  adopt
       (m>1) OU    ->                  homologou      ->  homolog
       (m>1) ISM   ->                  communism      ->  commun
       (m>1) ATE   ->                  activate       ->  activ
       (m>1) ITI   ->                  angulariti     ->  angular
       (m>1) OUS   ->                  homologous     ->  homolog
       (m>1) IVE   ->                  effective      ->  effect
       (m>1) IZE   ->                  bowdlerize     ->  bowdler
   
       The suffixes are now removed. All that remains is a little tidying up. 
      */
      
      private function step4(str:String):String {
         _endList = [
               ["al", ""], 
               ["ance", ""], 
               ["ence", ""], 
               ["er", ""], 
               ["ic", ""], 
               ["able", ""], 
               ["ant", ""], 
               ["ement", ""], 
               ["ment", ""], 
               ["ent", ""], 
               ["sion", "s"], 
               ["tion", "t"], 
               ["ion", "ion"], 
               ["ou", ""], 
               ["ism", ""], 
               ["ate", ""], 
               ["iti", ""], 
               ["ous", ""], 
               ["ive", ""], 
               ["ize", ""]
             ]
          return swapEnds(str, MORE_THAN_TWO_SYLLABLE_LEFT)
      }
      
      
      /*
      
       STEP 5a
   
       (m>1) E     ->                  probate        ->  probat
                                       rate           ->  rate
       (m=1 and not *o) E ->           cease          ->  ceas
   
        STEP 5b
   
       (m>1 and *d and *L) -> single letter
                                       controll       ->  control
                                       roll           ->  roll
      */
      private function step5(str:String):String {
         // Step5a - mute e
         _endList = [
               ["e", ""]
             ]
          str = swapEnds(str, FINAL_E_IS_MUTE)

         // Step5b - reduce double ll
          
         if(WordManip.countSyllables(str) > 1 &&
            WordManip.hasFinalLetters(str, "ll")) 
         {
            str = WordManip.removeFinalLetters(str, 1)  
         } 
         
         return str
      }
      
      
      /**
      *  Generic function for swapping ends, applying conditions if 
      *  required
      */
      private function swapEnds(str:String, conditions:String=""):String {
         var endList:Array = _endList
         var temp:String 
         var match:String
         var replace:String
         var passConditions:Boolean = true 
         for (var i:uint = 0; i < endList.length; i++) {
            match = endList[i][0]
            replace = endList[i][1]
            if(WordManip.hasFinalLetters(str, match))
            {
               temp = WordManip.removeFinalLetters(str, match.length)
               var syllableQty:Number = WordManip.countSyllables(temp)
               var endCvc:Boolean = WordManip.hasCvcFinalLetters(temp)
               var hasVowel:Boolean = WordManip.hasVowel(temp)

               if(conditions.indexOf(MORE_THAN_ONE_SYLLABLE_LEFT) > -1) {
                  if(syllableQty < 1) 
                     passConditions = false
               }
               if(conditions.indexOf(MORE_THAN_TWO_SYLLABLE_LEFT) > -1) {
                  if(syllableQty < 2) 
                     passConditions = false
               }
               if(conditions.indexOf(HAS_VOWEL_LEFT) > -1) {
                  if(hasVowel == false) 
                     passConditions = false
               }
               if(conditions.indexOf(FINAL_E_IS_MUTE) > -1) {
                   if(syllableQty > 1 || (syllableQty == 1 && !endCvc))
                     passConditions = true
                   else 
                     passConditions = false
               }
               
               if(passConditions) 
               {
                  str  = WordManip.removeFinalLetters(str, match.length)
                  str = WordManip.addFinalLetters(str, replace)
                  
               }
               break // first match wins
            }
         } 
         return str  
      }
           
     
   }
}