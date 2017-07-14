/*
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package {

import com.freshplanet.ane.AirCrashlytics.AirCrashlytics;
import com.freshplanet.ane.AirCrashlytics.events.AirCrashlyticsEvent;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.events.Event;

import com.freshplanet.ui.ScrollableContainer;
import com.freshplanet.ui.TestBlock;

[SWF(backgroundColor="#057fbc", frameRate='60')]
public class Main extends Sprite {

    public static var stageWidth:Number = 0;
    public static var indent:Number = 0;

    private var _scrollableContainer:ScrollableContainer = null;

    public function Main() {
        this.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
    }

    private function _onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
        this.stage.align = StageAlign.TOP_LEFT;

        stageWidth = this.stage.stageWidth;
        indent = stage.stageWidth * 0.025;

        _scrollableContainer = new ScrollableContainer(false, true);
        this.addChild(_scrollableContainer);

        if (!AirCrashlytics.isSupported) {

            trace("AirCrashlytics ANE is NOT supported on this platform!");
            return;
        }


        AirCrashlytics.instance.addEventListener(
                AirCrashlyticsEvent.CRASH_DETECTED_DURING_PREVIOUS_EXECUTION,
                onCrashDetectedDuringPreviousExecution);

        var blocks:Array = [];

        blocks.push(new TestBlock("start Crashlytics", function():void {
            AirCrashlytics.instance.start(false);
        }));
        blocks.push(new TestBlock("simulate crash", function():void {
            AirCrashlytics.instance.crash();
        }));




        /**
         * add ui to screen
         */

        var nextY:Number = indent;

        for each (var block:TestBlock in blocks) {

            _scrollableContainer.addChild(block);
            block.y = nextY;
            nextY +=  block.height + indent;
        }
    }

    private function onCrashDetectedDuringPreviousExecution(event:AirCrashlyticsEvent):void {

        var crashData:Object = event.data;
        trace("Crash detected during previous execution: ", crashData);
    }
}
}
