-- use scripting additions

set SystemLanguage to do shell script "defaults read .GlobalPreferences AppleLanguages | tr -d '[:space:]()' | cut -c2-3"
set translations to {en: {textDisconnected: "Disconnected",textVerificationCode: "Verification code",buttonConnect: "Connect",buttonVerify: "Verify"}, ko: {textDisconnected: "연결 해제됨",textVerificationCode: "인증 코드",buttonConnect: "연결",buttonVerify: "확인"}}

set tl to getProperTranslation(translations, SystemLanguage)
log textDisconnected of tl

on getProperTranslation(translations, lang)
    script inner
        property parent : a reference to current application
        use framework "Foundation"
        on getProperTranslation(translations, lang)
            set dict to current application's NSDictionary's dictionaryWithDictionary:translations

            set tl to missing value
            repeat with l in dict's allKeys()
                if lang is l as text then
                    set tl to (dict's valueForKey:l) as record
                    exit repeat
                end if
            end repeat

            -- fallback
            if tl is missing value then
                set tl to (dict's valueForKey:"en") as record
            end if

            return tl
        end getProperTranslation
    end script

    return inner's getProperTranslation(translations, lang)
end getProperTranslation
