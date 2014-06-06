/*
 * Copyright (C) 2013 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.android.glass.sample.apidemo.card;

import com.google.android.glass.app.Card;
import com.google.android.glass.app.Card.ImageLayout;
import com.google.android.glass.media.Sounds;
import com.google.android.glass.sample.apidemo.ApiDemoActivity;
import com.google.android.glass.sample.apidemo.R;
import com.google.android.glass.widget.CardScrollAdapter;
import com.google.android.glass.widget.CardScrollView;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.media.SoundPool;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Creates a card scroll view with examples of different image layout cards.
 */
public final class SoundActivity extends Activity {
	   private CardScrollAdapter mAdapter;
	   public static String url;
	   private SoundPool mSoundPool;
    private CardScrollView mCardScroller;

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        mAdapter = new CardAdapter(createCards(this));
        mCardScroller = new CardScrollView(this);
        mCardScroller.setAdapter(new CardAdapter(createCards(this)));
        setContentView(mCardScroller);
        setCardScrollerListener();
    }

    /**
     * Create list of cards that showcase different type of {@link Card} API.
     */
    private List<Card> createCards(Context context) {
        ArrayList<Card> cards = new ArrayList<Card>();
        cards.add(0, new Card(context).setText("Station 1"));
        cards.add(1, new Card(context).setText("Station 2"));
     
        return cards;
    }
    private void setCardScrollerListener() {
        mCardScroller.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                int soundEffect = Sounds.TAP;
                switch (position) {
                    case 0:
                    	openSoundStream("http://www.enactforum.org/test.mp3");
                      //  startActivity(new Intent(CardsActivity.this, SoundActivity.class));
                        break;
                    case 1:
                    	openSoundStream("http://www.enactforum.org/test.mp3");
                    	// startActivity(new Intent(CardsActivity.this, SoundActivity.class));
                        break;
                    default:
                        soundEffect = Sounds.ERROR;
                }

                // Play sound.
                AudioManager am = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
                am.playSoundEffect(soundEffect);
            }
        });
    }
   
    void openSoundStream(String url) {         

    	  mSoundPool = new SoundPool(1, AudioManager.STREAM_MUSIC, 0);
    	  mSoundPool.load(url, 0);
    	  mSoundPool.setOnLoadCompleteListener(new SoundPool.OnLoadCompleteListener() {
              @Override
              public void onLoadComplete(SoundPool soundPool, int sampleId, int status) {
                  soundPool.play(sampleId, 1.0f, 1.0f, 0, 0, 1.0f);
                  int soundEffect = Sounds.TAP;
                  AudioManager am = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
                  am.playSoundEffect(soundEffect);
                  am.playSoundEffect(soundEffect);
                  am.playSoundEffect(soundEffect);
              }
          });
    }
    @Override
    protected void onResume() {
        super.onResume();
        mCardScroller.activate();
        if (mSoundPool != null){
        	  mSoundPool.autoResume();
        }
      
    }

    @Override
    protected void onPause() {
        mCardScroller.deactivate();
        mSoundPool.autoPause();
        super.onPause();
    }
}
