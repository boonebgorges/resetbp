#!/bin/bash

database=$1
declare -a droptables=(wp_bp_activity wp_bp_activity_meta wp_bp_friends wp_bp_groups wp_bp_groups_groupmeta wp_bp_groups_members wp_bp_messages_messages wp_bp_messages_notices
wp_bp_messages_recipients wp_bp_notifications wp_bp_user_blogs wp_bp_user_blogs_blogmeta  wp_bp_xprofile_data wp_bp_xprofile_fields wp_bp_xprofile_groups wp_bp_xprofile_meta wp_bb_forums wp_bb_meta wp_bb_posts wp_bb_terms wp_bb_term_relationships wp_bb_term_taxonomy wp_bb_topics)

len=${#droptables[@]}
for(( i=0; i<$len; i++))
do
	sql="USE $database;DROP TABLE ${droptables[$i]};"
	mysql -u root --password=root <<< $sql
done


sql="USE $database;DELETE FROM wp_options WHERE option_name LIKE 'bp-%';
     USE $database;DELETE FROM wp_options WHERE option_name LIKE 'bp_%';
     USE $database;DELETE FROM wp_options WHERE option_name LIKE '_bp_%';"
mysql -u root --password=root <<< $sql

sql="USE $database;DELETE FROM wp_sitemeta WHERE meta_key LIKE 'bp-%';"
mysql -u root --password=root <<< $sql

#Switch back to Twenty Ten
sql="USE $database;UPDATE wp_options SET option_value = 'twentyten' WHERE option_name = 'stylesheet' OR option_name = 'template';"
mysql -u root --password=root <<< $sql
