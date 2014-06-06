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

package com.google.android.glass.sample.apidemo;

import com.google.android.glass.app.Card;
import com.google.android.glass.media.Sounds;
import com.google.android.glass.sample.apidemo.card.CardsActivity;
import com.google.android.glass.sample.apidemo.card.CardAdapter;
import com.google.android.glass.sample.apidemo.card.ImgActivity;
import com.google.android.glass.sample.apidemo.card.ImgActivity2;
import com.google.android.glass.sample.apidemo.card.ImgActivity3;
import com.google.android.glass.sample.apidemo.card.ImgActivity4;
import com.google.android.glass.sample.apidemo.card.SoundActivity;
import com.google.android.glass.sample.apidemo.opengl.OpenGlService;
import com.google.android.glass.sample.apidemo.theming.ThemingActivity;
import com.google.android.glass.sample.apidemo.touchpad.SelectGestureDemoActivity;
import com.google.android.glass.widget.CardScrollAdapter;
import com.google.android.glass.widget.CardScrollView;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;

import java.util.ArrayList;
import java.util.List;

/**
 * Creates a card scroll view with examples of different GDK APIs.
 *
 * <ol>
 * <li> Cards
 * <li> GestureDetector
 * <li> textAppearance[Large|Medium|Small]
 * <li> OpenGL LiveCard
 * </ol>
 */
public class ApiDemoActivity extends Activity {

    private static final String TAG = "Bieber Me";//ApiDemoActivity.class.getSimpleName();

    // Index of api demo cards.
    // Visible for testing.
    static final int CARDS = 0;
    static final int SIRI = 2;
    static final int RADIO = 1;

    private CardScrollAdapter mAdapter;
    private CardScrollView mCardScroller;

    // Visible for testing.
    CardScrollView getScroller() {
        return mCardScroller;
    }

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);

        mAdapter = new CardAdapter(createCards(this));
        mCardScroller = new CardScrollView(this);
        mCardScroller.setAdapter(mAdapter);
        setContentView(mCardScroller);
        setCardScrollerListener();
    }

    /**
     * Create list of API demo cards.
     */
    private List<Card> createCards(Context context) {
        ArrayList<Card> cards = new ArrayList<Card>();
        cards.add(CARDS, new Card(context).setText("Websites"));
        cards.add(RADIO, new Card(context).setText("RADIO"));
        cards.add(SIRI, new Card(context).setText("SIRI"));
        cards.add(3, new Card(context).setText("Images 1"));
        cards.add(4, new Card(context).setText("Images 2"));
        cards.add(5, new Card(context).setText("Images 3"));
        cards.add(6, new Card(context).setText("Images 4"));
        return cards;
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

    /**
     * Different type of activities can be shown, when tapped on a card.
     */
    private void setCardScrollerListener() {
        mCardScroller.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Log.d(TAG, "Clicked view at position " + position + ", row-id " + id);
                int soundEffect = Sounds.TAP;
                switch (position) {
                    case CARDS:
                        startActivity(new Intent(ApiDemoActivity.this, CardsActivity.class));
                        break;
                    case RADIO:
                    	startActivity(new Intent(ApiDemoActivity.this, SoundActivity.class));
                        break;
                    case SIRI:
                    	callhomebutton();
                        break;
                    case 3:
                    	  startActivity(new Intent(ApiDemoActivity.this, ImgActivity.class));
                          break;
                    case 4:
                  	  startActivity(new Intent(ApiDemoActivity.this, ImgActivity2.class));
                        break;
                    case 5:
                  	  startActivity(new Intent(ApiDemoActivity.this, ImgActivity3.class));
                        break;
                    case 6:
                    	  startActivity(new Intent(ApiDemoActivity.this, ImgActivity4.class));
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
    void callhomebutton(){
    	//Intent intent = new Intent(Intent.ACTION_VOICE_COMMAND);
    	Intent intent = new Intent(Intent.ACTION_CALL);
    	  startActivity(intent);
    }
}
