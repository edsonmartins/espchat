package br.com.espchat.entities;

import br.com.espchat.util.Constants;

/**
 *
 * @author edson
 */
public enum UserType {
    ESPCHAT,
    FACEBOOK,
    TWITTER,
    GOOGLE_PLUS;

    public static UserType getUserType(String loginSocialType) {
        if (loginSocialType.equals(Constants.FACEBOOK)) {
            return FACEBOOK;
        } else if (loginSocialType.equals(Constants.TWITTER)) {
            return TWITTER;
        } else if (loginSocialType.equals(Constants.GOOGLE_PLUS)) {
            return GOOGLE_PLUS;
        }
        return ESPCHAT;
    }
}
