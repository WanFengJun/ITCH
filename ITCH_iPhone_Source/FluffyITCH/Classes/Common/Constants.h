//
//  Constants.h
//  FluffyITCH
//
//  Created by Mimi on 7/3/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#ifndef FluffyITCH_Constants_h
#define FluffyITCH_Constants_h

#define SERVER_ADDRESS                  @"http://192.168.1.108"
#define LOGIN_URL                       @"/itch/service.php?api_name=login"
#define SIGNUP_URL                      @"/itch/service.php?api_name=signup"
#define GET_MEDICATION_LIST_URL         @"/itch/service.php?api_name=get_medication_list"
#define ADD_DOG_URL                     @"/itch/service.php?api_name=add_dog"
#define UPDATE_DOG_PROFILE_URL          @"/itch/service.php?api_name=update_dog_profile"
#define GET_DATA_URL                    @"/itch/service.php?api_name=get_data"
#define ADD_ITCH_RECORD_URL             @"/itch/service.php?api_name=add_itch_record"
#define GET_USED_MED_LIST_URL           @"/itch/service.php?api_name=get_used_medication_list"
#define START_MEDICATION_URL            @"/itch/service.php?api_name=start_medication"
#define STOP_MEDICATION_URL             @"/itch/service.php?api_name=stop_medication"
#define GET_USED_BATHING_LIST_URL       @"/itch/service.php?api_name=get_bathing_history_list"
#define START_BATHING_URL               @"/itch/service.php?api_name=start_bathing"
#define STOP_BATHING_URL                @"/itch/service.php?api_name=stop_bathing"
#define GET_FLEA_URL                    @"/itch/service.php?api_name=get_flea"
#define SET_FLEA_URL                    @"/itch/service.php?api_name=set_flea"
#define GET_USED_FOOD_LIST_URL          @"/itch/service.php?api_name=get_used_food_list"
#define START_FOOD_URL                  @"/itch/service.php?api_name=start_food"
#define STOP_FOOD_URL                   @"/itch/service.php?api_name=stop_food"
#define USED_MED_CHECK_URL              @"/itch/service.php?api_name=used_med_check"
#define GET_ALL_HISTORY_URL             @"/itch/service.php?api_name=get_all_history"
#define GET_GRAPH_DATA_URL              @"/itch/service.php?api_name=get_graph_data"
#define GET_COMMUNITY_LIST_URL          @"/itch/service.php?api_name=get_community_list"
#define ADD_COMMUNITY_URL               @"/itch/service.php?api_name=add_community"
#define ADD_COMMENT_URL                 @"/itch/service.php?api_name=add_comment"
#define GET_COMMENT_LIST_URL            @"/itch/service.php?api_name=get_community_comment_list"

#define PHOTO_BASE_URL                  @"/itch/uploads/"
#define COMMUNITY_PHOTO_BASE_URL        @"/itch/uploads/community/"
#define COMMENT_PHOTO_BASE_URL          @"/itch/uploads/comment/"

#define WEATHER_SERVER_URL              @"http://api.wunderground.com/"
#define WEATHER_API_KEY                 @"29177338b96ec02f"

#define PARAM_KEY_USERNAME              @"username"
#define PARAM_KEY_PASSWORD              @"password"
#define PARAM_KEY_SUCCESS               @"success"
#define PARAM_KEY_ERROR_TYPE            @"error_type"
#define PARAM_KEY_MESSAGE               @"message"
#define PARAM_KEY_DATA                  @"data"
#define PARAM_KEY_USERID                @"userId"
#define PARAM_KEY_EMAIL                 @"email"
#define PARAM_KEY_REGISTER_DATE         @"registerDate"

#define PARAM_KEY_MEDICATION            @"medication"
#define PARAM_KEY_MEDID                 @"medId"
#define PARAM_KEY_MED_NAME              @"med_name"
#define PARAM_KEY_MED_UNIT              @"med_unit"
#define PARAM_KEY_MED_CYCLE_TYPE        @"med_cycle_type"
#define PARAM_KEY_MED_CYCLE_VALUE       @"med_cycle_value"
#define PARAM_KEY_IS_ON                 @"is_on"

#define PARAM_KEY_DOG                   @"dog"
#define PARAM_KEY_DOG_ID                @"dogId"
#define PARAM_KEY_DOG_NAME              @"dog_name"
#define PARAM_KEY_DOG_BIRTH             @"dog_birth"
#define PARAM_KEY_DOG_GENDER            @"dog_gender"
#define PARAM_KEY_DOG_BREED             @"dog_breed"
#define PARAM_KEY_DOG_DOOR              @"dog_door"
#define PARAM_KEY_DOG_PHOTO             @"dog_photo"

#define PARAM_KEY_FOOD                  @"food"
#define PARAM_KEY_FOOD_ID               @"foodId"
#define PARAM_KEY_FOOD_NAME             @"foot_name"

#define PARAM_KEY_DATE                  @"date"
#define PARAM_KEY_LEVEL                 @"level"
#define PARAM_KEY_LATITUDE              @"latitude"
#define PARAM_KEY_LONGITUDE             @"longitude"

#define PARAM_KEY_BATHING               @"bathing"
#define PARAM_KEY_BATHING_ID            @"bathingId"
#define PARAM_KEY_BATHING_NAME          @"bathing_name"

#define PARAM_KEY_FREQUENCY             @"frequency"
#define PARAM_KEY_UNIT                  @"unit"
#define PARAM_KEY_ID                    @"id"
#define PARAM_KEY_FREQUENCY_ID          @"frequencyId"
#define PARAM_KEY_UNIT_ID               @"unitId"
#define PARAM_KEY_CHECK_COUNT           @"check_count"
#define PARAM_KEY_CHECK_INDEX           @"check_index"
#define PARAM_KEY_START_DATE            @"start_date"
#define PARAM_KEY_DATE                  @"date"
#define PARAM_KEY_STOP_DATE             @"stop_date"

#define PARAM_KEY_IS_ON                 @"is_on"

#define PARAM_KEY_CYCLE                 @"cycle"

#define PARAM_KEY_COUNT_VALUE           @"count_value"

#define PARAM_KEY_ITCH                  @"itch"
#define PARAM_KEY_RECORD_ID             @"recordId"
#define PARAM_KEY_FLEA                  @"flea"
#define PARAM_KEY_FLEA_ID               @"fealId"

#define PARAM_KEY_DATE1                 @"date1"
#define PARAM_KEY_DATE2                 @"date2"
#define PARAM_KEY_DATE3                 @"date3"
#define PARAM_KEY_DATE4                 @"date4"
#define PARAM_KEY_DATE5                 @"date5"

#define PARAM_KEY_COMMUNITY_ID          @"communityId"
#define PARAM_KEY_TITLE                 @"title"
#define PARAM_KEY_CONTENT               @"content"
#define PARAM_KEY_PHOTO_URL             @"photo_url"
#define PARAM_KEY_COMMENT_COUNT         @"comment_count"
#define PARAM_KEY_SERVER_CUR_TIME       @"server_time"
#define PARAM_KEY_PHOTO                 @"photo"
#define PARAM_KEY_COMMENT               @"comment"
#define PARAM_KEY_COMMENT_ID            @"commentId"

#define NOTIFICATION_CHANGE_DOG         @"notification_change_dog"
#define NOTIFICATION_HISTORY_CHANGE_DOG @"notification_history_change_dog"
#define NOTIFICATION_REPORT_CHAGE_DOG   @"notification_report_change_dog"
#define NOTIFICATION_CHAGE_DOG_PHOTO    @"notification_change_dog_photo"
#define NOTIFICATION_ADD_DOG_PHOTO      @"notification_add_dog_photo"
#define NOTIFICATION_ADDED_COMMUNITY    @"notification_added_community"
#define NOTIFICATION_ADDED_COMMENT      @"notification_added_comment"

#define CYCLE_TYPE_DAY                  1
#define CYCLE_TYPE_HOUR                 2
#define CYCLE_TYPE_DAY_STRING           @"day"
#define CYCLE_TYPE_HOUR_STRING          @"hour"

#define KEY_USERNAME            @"username"
#define KEY_PASSWORD            @"password"

#endif
