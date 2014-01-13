package com.freshplanet.ane.AirCrashlytics.activities;

import com.crashlytics.android.Crashlytics;

import android.app.Activity;
import android.os.Bundle;

public class CrashActivity extends Activity
{
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		Crashlytics.getInstance().crash();
	}
}