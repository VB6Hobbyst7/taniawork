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
import com.google.android.glass.sample.apidemo.card.SoundActivity;
import com.google.android.glass.sample.apidemo.R;
import com.google.android.glass.widget.CardScrollAdapter;
import com.google.android.glass.widget.CardScrollView;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;

import java.util.ArrayList;
import java.util.List;

/**
 * Creates a card scroll view with examples of different image layout cards.
 */
public final class CardsActivity extends Activity {
	   private static final String TAG = "Bieber Me";//ApiDemoActivity.class.getSimpleName();
	    // Index of api demo cards.
	    // Visible for testing.
	    static final int RLSBB = 0;
	    static final int DOWNTR = 1;
	    private CardScrollAdapter mAdapter;
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
        cards.add(RLSBB, new Card(context).setText("RLSBB"));
        cards.add(DOWNTR, new Card(context).setText("DOWNTR"));
     
        return cards;
    }
    private void setCardScrollerListener() {
        mCardScroller.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                int soundEffect = Sounds.TAP;
              
                switch (position) {
                    case RLSBB:
                    	openWebPage("http://www.rlsbb.com");
                      //  startActivity(new Intent(CardsActivity.this, SoundActivity.class));
                        break;
                    case DOWNTR:
                    	openWebPage("http://www.downtr.co");
                    	// startActivity(new Intent(CardsActivity.this, SoundActivity.class));
                        break;
                    default:
                        soundEffect = Sounds.ERROR;
                        Log.d(TAG, "Don't show anything");
                }

                // Play sound.
                AudioManager am = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
                am.playSoundEffect(soundEffect);
            }
        });
    }
   
    void openWebPage(String url) {         
    	Uri webpage = Uri.parse(url);Intent intent = new Intent(Intent.ACTION_VIEW, webpage);       if (intent.resolveActivity(getPackageManager()) != null) 
    	   {
    		if (intent.resolveActivity(getPackageManager()) != null) 
    		{
    		    startActivity(intent);
    		    finish();
    		}    
    	    } 
    	}
    @Override
    protected void onResume() {
        super.onResume();
        mCardScroller.activate();
    }

    @Override
    protected void onPause() {
        mCardScroller.deactivate();
        super.onPause();
    }
}
