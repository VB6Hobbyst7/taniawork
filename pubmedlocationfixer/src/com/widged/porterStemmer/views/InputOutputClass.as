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
package com.widged.porterStemmer.views
{

   import mx.containers.HBox;

   /**
   * Class Behind for the InputOutputComponent
   */
   public class InputOutputClass extends HBox
   {

      import mx.controls.TextArea;
      import flash.events.Event
      import com.widged.porterStemmer.PorterAlgorithm;
      
      
      // controls that we want to be able to reference from here
      //  because of some Flex oddity, they need to be declared as 
      // public rather than protected
      [Bindable] public var stemmerInput:TextArea
      public var stemmerOutput:TextArea
      public var inputXML:XML
      
      [Bindable] protected var areaHeight:uint = 400
      // private
      private var _stemmer:PorterAlgorithm

      /* ################
         Constructor
      ################ */
      public function InputOutputClass()
      {
         super();
      }
      
      /* ################
         Events / Interactivity
      ################ */
      protected function onCreationComplete():void 
      {
         loadTestCases()
      }
      
      protected function onStemClick():void 
      {
         stemWordList()
      }
      
      protected function onTestCasesClick():void 
      {
         loadTestCases()
      }
      
      /* ################
         View
      ################ */
      private function getInputText():String
      {
         return stemmerInput.text
      }
      
      private function setInputText(str:String):void
      {
         stemmerInput.text = str
      }

      private function setOutputText(str:String):void
      {
         stemmerOutput.text = str
      }
      
      /* ################
         Model
      ################ */
      private function stemWordList():void 
      {
         var words:String = getInputText()
         var wordList:Array = words.split("\r")
         _stemmer = new PorterAlgorithm()
         var stemList:Array = _stemmer.listStem(wordList)
         setOutputText(stemList.join("\n"))
      }

      private function loadTestCases():void 
      {
       	var wordList:Array = []
			for each (var i:XML in inputXML..word)
         wordList.push(i)
			setInputText( wordList.join("\n"))
			setOutputText("")
      }
      
     
   }
}