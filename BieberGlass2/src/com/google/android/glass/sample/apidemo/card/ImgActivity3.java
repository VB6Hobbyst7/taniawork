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
public final class ImgActivity3 extends Activity {
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
        Card  card=new Card(context);
        card.addImage(R.drawable.img50); 
        card.addImage(R.drawable.img51);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img54);
        card.addImage(R.drawable.img52);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img53); 
        card.addImage(R.drawable.img55);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img56);
        card.addImage(R.drawable.img57);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img58);
        card.addImage(R.drawable.img59);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img6);
        card.addImage(R.drawable.img60);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img61);
        card.addImage(R.drawable.img62);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img63);
        card.addImage(R.drawable.img64);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img65);
        card.addImage(R.drawable.img66);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img67);
        card.addImage(R.drawable.img68);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img69);
        card.addImage(R.drawable.img7);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img70);
        card.addImage(R.drawable.img71);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img72);
        card.addImage(R.drawable.img73);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img74);
        card.addImage(R.drawable.img75);
         cards.add(card.setImageLayout(ImageLayout.FULL).setText(""));
        card=new Card(context);
        card.addImage(R.drawable.img8);
        card.addImage(R.drawable.img9);
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
