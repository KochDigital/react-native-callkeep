package io.wazo.callkeep;

import com.facebook.react.bridge.ReadableMap;

public interface IncomingCallActivityInterface {
    static boolean active = false;
    public void onConnected();

    public void onDisconnected();

    public void onConnectFailure();

    public void onIncoming(ReadableMap params);
}
