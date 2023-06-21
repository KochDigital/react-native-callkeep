package io.wazo.callkeep;

public class Constants {
    public static final String ACTION_ANSWER_CALL = "ACTION_ANSWER_CALL";
    public static final String ACTION_AUDIO_SESSION = "ACTION_AUDIO_SESSION";
    public static final String ACTION_CHECK_REACHABILITY = "ACTION_CHECK_REACHABILITY";
    public static final String ACTION_DTMF_TONE = "ACTION_DTMF_TONE";
    public static final String ACTION_END_CALL = "ACTION_END_CALL";
    public static final String ACTION_HOLD_CALL = "ACTION_HOLD_CALL";
    public static final String ACTION_MUTE_CALL = "ACTION_MUTE_CALL";
    public static final String ACTION_ONGOING_CALL = "ACTION_ONGOING_CALL";
    public static final String ACTION_UNHOLD_CALL = "ACTION_UNHOLD_CALL";
    public static final String ACTION_UNMUTE_CALL = "ACTION_UNMUTE_CALL";
    public static final String ACTION_WAKE_APP = "ACTION_WAKE_APP";
    public static final String ACTION_SHOW_INCOMING_CALL_UI = "ACTION_SHOW_INCOMING_CALL_UI";
    public static final String ACTION_ON_SILENCE_INCOMING_CALL = "ACTION_ON_SILENCE_INCOMING_CALL";
    public static final String ACTION_ON_CREATE_CONNECTION_FAILED = "ACTION_ON_CREATE_CONNECTION_FAILED";
    public static final String ACTION_DID_CHANGE_AUDIO_ROUTE = "ACTION_DID_CHANGE_AUDIO_ROUTE";
    public static final String ACTION_DISMISS_CALL_UI = "ACTION_DISMISS_CALL_UI";


    public static final String EXTRA_CALL_NUMBER = "EXTRA_CALL_NUMBER";
    public static final String EXTRA_CALL_NUMBER_SCHEMA = "EXTRA_CALL_NUMBER_SCHEMA";
    public static final String EXTRA_CALL_UUID = "EXTRA_CALL_UUID";
    public static final String EXTRA_CALLER_NAME = "EXTRA_CALLER_NAME";
    public static final String EXTRA_HAS_VIDEO = "EXTRA_HAS_VIDEO";
    // Can't use telecom.EXTRA_DISABLE_ADD_CALL ...
    public static final String EXTRA_DISABLE_ADD_CALL = "android.telecom.extra.DISABLE_ADD_CALL";

    public static final String NOTIFICATION_CHANNEL_ID_CALL = "cs_notification_channel_call";
    public static final int NOTIFICATION_ID_INCOMING_CALL = 1337;

    public static final int REQUEST_CODE_ACCEPT_CALL = 1000;
    public static final int REQUEST_CODE_END_CALL = 1001;

    public static final int FOREGROUND_SERVICE_TYPE_MICROPHONE = 128;

    public static final String ACTION_CALL_ANSWER = "io.wazo.callkeep.ACTION_CALL_ANSWER";
    public static final String ACTION_CALL_END = "io.wazo.callkeep.ACTION_CALL_END";
}
