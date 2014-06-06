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
   public class InputExpectedOutputClass extends HBox
   {

      import flash.events.Event

      import flash.filesystem.File;
      import flash.filesystem.FileMode;
      import flash.filesystem.FileStream;

      import mx.controls.TextArea;
      import mx.controls.TextInput;
   
      import mx.controls.DataGrid;
      import mx.collections.XMLListCollection
      import mx.collections.ICollectionView;
      import mx.controls.dataGridClasses.DataGridColumn

      import com.widged.porterStemmer.PorterAlgorithm;

      private const LOOP_GET:uint = 1;
      private const LOOP_PUT:uint = 2;

      // controls that we want to be able to reference from here
      //  because of some Flex oddity, they need to be declared as 
      // public rather than protected
      [Bindable] public var stemmerInput:TextArea;
      public var stemmerExpected:TextArea
      public var stemmerOutput:TextArea
      public var filterValue:TextInput
      public var inputXML:XML
      public var dataGrid:DataGrid
      
      [Bindable] protected var vocabularyCollection:XMLListCollection;
      [Bindable] protected var bodyPadding:uint = 20;
      
      // private
      private var _stemmer:PorterAlgorithm
      private var _dir:File
      private var _path:String
      private var _fileName:String
      private var _fileStream : FileStream;
      private var vocabularyFile:File
      private var vocabularyFilter:String
      private var vocabularyXML : XML;

     //  private const ISO_CS : String = "iso-8859-1";

      /* ################
         Constructor
      ################ */
      public function InputExpectedOutputClass()
      {
         super();
         _dir = File.applicationDirectory;
         _path = "etc/"
         _fileName = "sampleVocabulary_full.xml"
         vocabularyCollection = new XMLListCollection()
         _stemmer = new PorterAlgorithm()
         
      }
      
      
      /* ################
         Events / Interactivity
      ################ */
      protected function onCreationComplete():void  { loadVocabulary() }
      
      protected function onVocabularyClick():void 
      {
         loadVocabulary()
      }

      protected function onStemClick():void 
      {
         stemVisibleWords()
         updateVocabulary()
         
      }
      protected function onFilterEnter():void
      {
         updateVocabulary()
      }
      protected function onGridScroll():void 
      {
         stemVisibleWords()
         updateVocabulary()
                  
      }
      
      /* ################
         View
      ################ */
      /**
      * Update the vocabularyCollection applying predefined filters.
      */
      private function updateVocabulary():void
      {
      	vocabularyCollection.filterFunction = filterInput;  
	      vocabularyCollection.refresh();
      }


      private function getFilterValue():String 
      {
         return filterValue.text
      }
      
      
      /* ################
         Input / Output
      ################ */

      private function loadVocabulary():void 
      {
        var vocabularyFile:File = _dir.resolvePath(_path + _fileName);
         if(!vocabularyFile.exists) 
         {
            trace("[loadVocabulary] file not found")
            // TBD. Throw some error
            // file = new File();
            // file.addEventListener(Event.SELECT, dirSelected);
            //file.browseForOpen("Select " + _fileName + " file");
         }
         else 
         {
           _fileStream = new FileStream();
           _fileStream.addEventListener( Event.COMPLETE, onVocabularyRead );
           _fileStream.openAsync( vocabularyFile, FileMode.READ );
         }
      }
      
      private function onVocabularyRead( event : Event ):void
      {
        trace("[onVocabularyRead] file loaded")
        vocabularyXML = XML(_fileStream.readUTFBytes(_fileStream.bytesAvailable)); 
        // if I was to read a text file, I would rather use: var fileContents:String = fileStream.readMultiByte( fileStream.bytesAvailable, ISO_CS );
        _fileStream.close();
        buildVocabularyFromWordList(XMLList(vocabularyXML.word))
      }

      /* ################
         Model
      ################ */
      /**
      *  Construct the vocabularyCollection using information found in a wordList. 
      *  The word list is a XMLList of the following structure:
      *      [word] <i>abandon</i><e>abandon</e>
      *      [word] <i>abandoned</i><e>abandon</e>
      *      [word] <i>abase</i><e>abas</e>
      *  where 'i' stands for input and 'e' for expected
      */
      private function buildVocabularyFromWordList(wordList:XMLList):void 
      {
        vocabularyCollection.source = wordList
        stemVisibleWords()
        updateVocabulary(); 
      }
      
      // change watcher
      // verticalScrollPosition

      /**
      *  Go through the list and stem it
      */
      private function stemVisibleWords():void 
      {
         var wordList:Array = loopVisibleItemsInCollection(LOOP_GET); 
         var stemList:Array = _stemmer.listStem(wordList)
         loopVisibleItemsInCollection(LOOP_PUT, stemList)
      }

      private function loopVisibleItemsInCollection(mode:uint, arr:Array=null):Array 
      {
         // returned
         var words:Array = []

         var topIndex:int = dataGrid.verticalScrollPosition;   //  index of the item in the dataProvider which is being displayed at the top of the visible list, simply use the verticalScrollPosition:
         var visibleItemQty:int = ICollectionView(dataGrid.dataProvider).length - dataGrid.maxVerticalScrollPosition; // To determine how many rows are currently visible in the visible list:

         for (var i:int = 0; i < visibleItemQty; i++) 
         {
            var v:int = i + topIndex
            switch(mode) 
            {
               case LOOP_GET:
                  if(vocabularyCollection[v].o != undefined)
                     words.push("0") 
                          // skip the items for which the output has already been computed
                          // the algorithm is fully deterministic. Values remain unchanged
                          // words of less than two letters are returned without parsing.
                  else 
                     words.push(vocabularyCollection[v].i)
                  break;
               case LOOP_PUT:
                  
                  if(arr[i], arr[i].toString() == "0")
                     break    // skip the word that have been marked for skipping
                  vocabularyCollection[v].o = arr[i]
                  if(arr[i] != vocabularyCollection[v].e)
                     vocabularyCollection[v].c = "error"
                  break
            }
          }
          return words;
      }
      
      protected function filterInput(item:Object):Boolean   
      {
         vocabularyFilter = getFilterValue()
         if(vocabularyFilter == "") 
            return true
         
         var regexp:RegExp = new RegExp(vocabularyFilter, "i")    
      	return item.i.match(regexp)
      }

       
   }
}