package io.wazo.callkeep;

import static io.wazo.callkeep.Constants.ACTION_ANSWER_CALL;
import static io.wazo.callkeep.Constants.ACTION_CALL_ANSWER;
import static io.wazo.callkeep.Constants.EXTRA_CALL_UUID;
import static io.wazo.callkeep.Constants.NOTIFICATION_ID_INCOMING_CALL;

import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import java.util.HashMap;

public class IncomingCallReceiver extends BroadcastReceiver {
    private Context context;
    private final String TAG = "IncomingCallReceiver";

    @Override
    public void onReceive(Context context, Intent intent) {
        this.context = context;
        String action = intent.getAction();

        HashMap<String, String> attributeMap = (HashMap<String, String>)intent.getSerializableExtra("attributeMap");
        String uuid = attributeMap.get(EXTRA_CALL_UUID);

        Log.d(TAG, "onReceive: " + action + " uuid: " + uuid);

        NotificationManager notificationManager = context.getSystemService(
                NotificationManager.class);
        notificationManager.cancel(uuid, NOTIFICATION_ID_INCOMING_CALL);

        if (action.equals(ACTION_CALL_ANSWER)) {
            RNCallKeepModule.instance.answerIncomingCall(uuid);
            return;
        }
        if (action.equals(Constants.ACTION_CALL_END)) {
            RNCallKeepModule.instance.rejectCall(uuid);
            return;
        }
    }

    /*
     * Send call request to the RNCallKeepModule
     */
    private void sendCallRequestToActivity(final String action, @Nullable final HashMap attributeMap) {
        final IncomingCallReceiver instance = this;
        final Handler handler = new Handler();

        handler.post(new Runnable() {
            @Override
            public void run() {
                Intent intent = new Intent(action);
                if (attributeMap != null) {
                    Bundle extras = new Bundle();
                    extras.putSerializable("attributeMap", attributeMap);
                    intent.putExtras(extras);
                }
                LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
            }
        });
    }
}
