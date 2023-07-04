package com.carusto.ReactNativePjSip;

import org.pjsip.pjsua2.SipHeader;
import org.pjsip.pjsua2.SipHeaderVector;

import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PjSipUtils {

    public static SipHeaderVector mapToSipHeaderVector(Map<String, String> headers) {
        SipHeaderVector hdrsVector = new SipHeaderVector();

        for (Map.Entry<String, String> entry : headers.entrySet()) {
            SipHeader hdr = new SipHeader();
            hdr.setHName(entry.getKey());
            hdr.setHValue(entry.getValue());

            hdrsVector.add(hdr);
        }

        return hdrsVector;
    }

    public static String[] getNameAndNumberFromUri(String remoteUri) {
        String remoteNumber = null;
        String remoteName = null;

        if (remoteUri != null && !remoteUri.isEmpty()) {
            Pattern patternWithName = Pattern.compile("\"([^\"]+)\" <sip:([^@]+)@");
            Matcher matcherWithName = patternWithName.matcher(remoteUri);

            Pattern patternWithoutName = Pattern.compile("sip:([^@]+)@");
            Matcher matcherWithoutName = patternWithoutName.matcher(remoteUri);

            if (matcherWithName.find()) {
                remoteName = matcherWithName.group(1);
                remoteNumber = matcherWithName.group(2);
            } else if (matcherWithoutName.find()) {
                remoteNumber = matcherWithoutName.group(1);
            }
        }

        return new String[] { remoteName, remoteNumber };
    }

}
