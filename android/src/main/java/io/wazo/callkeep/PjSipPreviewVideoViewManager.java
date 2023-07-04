package io.wazo.callkeep;

import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;

// import org.pjsip.pjsua2.MediaFormatVector;


public class PjSipPreviewVideoViewManager extends SimpleViewManager<PjSipPreviewVideo>  {

    private String LOCAL_VIDEO_CLASS = "PjSipPreviewVideoView";

    @Override
    public String getName() {
        return LOCAL_VIDEO_CLASS;
    }

    @ReactProp(name = "deviceId")
    public void setDeviceId(PjSipPreviewVideo view, int deviceId) {
        view.setDeviceId(deviceId);
    }

    @ReactProp(name = "objectFit")
    public void setObjectFit(PjSipPreviewVideo view, String objectFit) {
        view.setObjectFit(objectFit);
    }

    @Override
    protected PjSipPreviewVideo createViewInstance(ThemedReactContext reactContext) {
        return new PjSipPreviewVideo(reactContext);
    }

}
