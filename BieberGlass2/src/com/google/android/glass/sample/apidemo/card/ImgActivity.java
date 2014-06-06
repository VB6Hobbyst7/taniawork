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
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Creates a card scroll view with examples of different image layout cards.
 */
public final class ImgActivity extends Activity {
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
    }

    /**
     * Create list of cards that showcase different type of {@link Card} API.
     */
    private List<Card> createCards(Context context) {
        ArrayList<Card> cards = new ArrayList<Card>();
        
        Card card=new Card(context);
        card.addImage(R.drawable.img1);
        card.addImage(R.drawable.img10);
        cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
         card=new Card(context);
        card.addImage(R.drawable.img11);
        card.addImage(R.drawable.img12);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img13);
        card.addImage(R.drawable.img14);
        cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img15);
        card.addImage(R.drawable.img16);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img17);
        card.addImage(R.drawable.img18);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img19);
        card.addImage(R.drawable.img2);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img20);
        card.addImage(R.drawable.img21);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img22);
        card.addImage(R.drawable.img23);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img24); 
        card.addImage(R.drawable.img25);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img26);
        card.addImage(R.drawable.img27);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img28);      
        card.addImage(R.drawable.img29);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img3);
        card.addImage(R.drawable.img30);
        cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
      
        
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
}
