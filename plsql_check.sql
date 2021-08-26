prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>2842970987618181
,p_default_application_id=>600
,p_default_owner=>'APEX_PLUGIN'
);
end;
/
prompt --application/shared_components/plugins/region_type/de_danielh_dropzone2
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(136310961796859786)
,p_plugin_type=>'REGION TYPE'
,p_name=>'DE.DANIELH.DROPZONE2'
,p_display_name=>'Dropzone 2'
,p_supported_ui_types=>'DESKTOP'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#js/dropzone#MIN#.js',
'#PLUGIN_FILES#js/apexdropzone#MIN#.js'))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#css/dropzone#MIN#.css',
'#PLUGIN_FILES#css/apexdropzone#MIN#.css'))
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*-------------------------------------',
' * Dropzone APEX Plugin',
' * Version: 2.4.1 (01.08.2018)',
' * Author:  Daniel Hochleitner',
' *-------------------------------------',
'*/',
'FUNCTION render_dropzone(p_region              IN apex_plugin.t_region,',
'                         p_plugin              IN apex_plugin.t_plugin,',
'                         p_is_printer_friendly IN BOOLEAN)',
'  RETURN apex_plugin.t_region_render_result IS',
'  --',
'  l_result apex_plugin.t_region_render_result;',
'  -- region attributes',
'  l_dz_style              p_region.attribute_07%TYPE := p_region.attribute_07;',
'  l_width                 p_region.attribute_08%TYPE := p_region.attribute_08;',
'  l_height                p_region.attribute_09%TYPE := p_region.attribute_09;',
'  l_max_filesize          NUMBER := p_region.attribute_10;',
'  l_max_files             NUMBER := p_region.attribute_11;',
'  l_accepted_files        p_region.attribute_13%TYPE := p_region.attribute_13;',
'  l_upload_mechanism      p_region.attribute_15%TYPE := p_region.attribute_15;',
'  l_dz_clickable          p_region.attribute_16%TYPE := p_region.attribute_16;',
'  l_show_file_preview     p_region.attribute_17%TYPE := p_region.attribute_17;',
'  l_copy_paste_support    p_region.attribute_18%TYPE := p_region.attribute_18;',
'  l_remove_uploaded_files p_region.attribute_19%TYPE := p_region.attribute_19;',
'  l_delete_files          p_region.attribute_20%TYPE := p_region.attribute_20;',
'  l_resize_images         p_region.attribute_22%TYPE := p_region.attribute_22;',
'  l_resize_width          p_region.attribute_23%TYPE := p_region.attribute_23;',
'  l_resize_height         p_region.attribute_24%TYPE := p_region.attribute_24;',
'  -- plugin attributes',
'  l_display_message            p_plugin.attribute_01%TYPE := p_plugin.attribute_01;',
'  l_fallback_message           p_plugin.attribute_02%TYPE := p_plugin.attribute_02;',
'  l_filetoobig_message         p_plugin.attribute_03%TYPE := p_plugin.attribute_03;',
'  l_maxfiles_message           p_plugin.attribute_04%TYPE := p_plugin.attribute_04;',
'  l_remove_file_message        p_plugin.attribute_05%TYPE := p_plugin.attribute_05;',
'  l_cancel_upload_message      p_plugin.attribute_06%TYPE := p_plugin.attribute_06;',
'  l_cancel_upl_confirm_message p_plugin.attribute_07%TYPE := p_plugin.attribute_07;',
'  l_invalid_filetype_message   p_plugin.attribute_08%TYPE := p_plugin.attribute_08;',
'  l_chunk_size                 p_plugin.attribute_09%TYPE := p_plugin.attribute_09;',
'  -- other variables',
'  l_region_id VARCHAR2(200);',
'  l_dz_class  VARCHAR2(50);',
'  -- js/css file vars',
'  l_filereader_js VARCHAR2(50);',
'  --',
'BEGIN',
'  -- Debug',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_region(p_plugin => p_plugin,',
'                                  p_region => p_region);',
'    -- set js/css filenames',
'    l_filereader_js := ''filereader'';',
'  ELSE',
'    l_filereader_js := ''filereader.min'';',
'  END IF;',
'  -- set variables and defaults',
'  l_region_id  := apex_escape.html_attribute(p_region.static_id ||',
'                                             ''_dropzone'');',
'  l_max_files  := nvl(l_max_files,',
'                      256);',
'  l_chunk_size := nvl(l_chunk_size,',
'                      1048576);',
'  -- escape input',
'  l_width                      := apex_escape.html(l_width);',
'  l_height                     := apex_escape.html(l_height);',
'  l_display_message            := apex_escape.html(l_display_message);',
'  l_fallback_message           := apex_escape.html(l_fallback_message);',
'  l_filetoobig_message         := apex_escape.html(l_filetoobig_message);',
'  l_maxfiles_message           := apex_escape.html(l_maxfiles_message);',
'  l_remove_file_message        := apex_escape.html(l_remove_file_message);',
'  l_cancel_upload_message      := apex_escape.html(l_cancel_upload_message);',
'  l_cancel_upl_confirm_message := apex_escape.html(l_cancel_upl_confirm_message);',
'  l_invalid_filetype_message   := apex_escape.html(l_invalid_filetype_message);',
'  --',
'  -- add div for dropzone',
'  -- style 1 (grey border)',
'  -- style 2 (blue dashed border)',
'  -- style 3 (red dashed border)',
'  -- style 4 (grey background and grey dashed border)',
'  l_dz_class := ''dz-'' || lower(l_dz_style);',
'  --',
'  htp.p(''<div id="'' || l_region_id || ''" class="dropzone '' || l_dz_class ||',
'        ''" style="width:'' || l_width || '';height:'' || l_height ||',
'        '';"></div>'');',
'  --',
'  -- filereader lib for Copy&Paste support',
'  IF l_copy_paste_support = ''true'' THEN',
'    apex_javascript.add_library(p_name           => l_filereader_js,',
'                                p_directory      => p_plugin.file_prefix ||',
'                                                    ''js/'',',
'                                p_version        => NULL,',
'                                p_skip_extension => FALSE);',
'  END IF;',
'  --',
'  -- onload code',
'  apex_javascript.add_onload_code(p_code => ''apexDropzone.pluginHandler('' ||',
'                                            apex_javascript.add_value(p_region.static_id) || ''{'' ||',
'                                            apex_javascript.add_attribute(''ajaxIdentifier'',',
'                                                                          apex_plugin.get_ajax_identifier) ||',
'                                            apex_javascript.add_attribute(''maxFilesize'',',
'                                                                          l_max_filesize) ||',
'                                            apex_javascript.add_attribute(''maxFiles'',',
'                                                                          l_max_files) ||',
'                                            apex_javascript.add_attribute(''acceptedFiles'',',
'                                                                          l_accepted_files) ||',
'                                            apex_javascript.add_attribute(''uploadMechanism'',',
'                                                                          l_upload_mechanism) ||',
'                                            apex_javascript.add_attribute(''clickable'',',
'                                                                          l_dz_clickable) ||',
'                                            apex_javascript.add_attribute(''showFilePreview'',',
'                                                                          l_show_file_preview) ||',
'                                            apex_javascript.add_attribute(''supportCopyPaste'',',
'                                                                          l_copy_paste_support) ||',
'                                            apex_javascript.add_attribute(''removeAfterUpload'',',
'                                                                          l_remove_uploaded_files) ||',
'                                            apex_javascript.add_attribute(''deleteFiles'',',
'                                                                          l_delete_files) ||',
'                                            apex_javascript.add_attribute(''resizeImages'',',
'                                                                          l_resize_images) ||',
'                                            apex_javascript.add_attribute(''resizeWidth'',',
'                                                                          l_resize_width) ||',
'                                            apex_javascript.add_attribute(''resizeHeight'',',
'                                                                          l_resize_height) ||',
'                                            apex_javascript.add_attribute(''pluginPrefix'',',
'                                                                          p_plugin.file_prefix) ||',
'                                            apex_javascript.add_attribute(''chunkSize'',',
'                                                                          l_chunk_size) ||',
'                                            apex_javascript.add_attribute(''displayMessage'',',
'                                                                          l_display_message) ||',
'                                            apex_javascript.add_attribute(''fallbackMessage'',',
'                                                                          l_fallback_message) ||',
'                                            apex_javascript.add_attribute(''fileTooBigMessage'',',
'                                                                          l_filetoobig_message) ||',
'                                            apex_javascript.add_attribute(''maxFilesMessage'',',
'                                                                          l_maxfiles_message) ||',
'                                            apex_javascript.add_attribute(''removeFileMessage'',',
'                                                                          l_remove_file_message) ||',
'                                            apex_javascript.add_attribute(''cancelUploadMessage'',',
'                                                                          l_cancel_upload_message) ||',
'                                            apex_javascript.add_attribute(''cancelUploadConfirmMessage'',',
'                                                                          l_cancel_upl_confirm_message) ||',
'                                            apex_javascript.add_attribute(''invalidFileTypeMessage'',',
'                                                                          l_invalid_filetype_message,',
'                                                                          FALSE,',
'                                                                          FALSE) ||',
'                                            ''});'');',
'  --',
'  RETURN l_result;',
'  --',
'END render_dropzone;',
'--',
'--',
'-- AJAX function',
'--',
'--',
'FUNCTION ajax_dropzone(p_region IN apex_plugin.t_region,',
'                       p_plugin IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_region_ajax_result IS',
'  --',
'  l_result apex_plugin.t_region_ajax_result;',
'  -- region attributes',
'  l_storage_type     p_region.attribute_01%TYPE := p_region.attribute_01;',
'  l_table_coll_name  p_region.attribute_02%TYPE := p_region.attribute_02;',
'  l_filename_column  p_region.attribute_03%TYPE := p_region.attribute_03;',
'  l_mimetype_column  p_region.attribute_04%TYPE := p_region.attribute_04;',
'  l_blob_column      p_region.attribute_05%TYPE := p_region.attribute_05;',
'  l_date_column      p_region.attribute_06%TYPE := p_region.attribute_06;',
'  l_pk_column        p_region.attribute_21%TYPE := p_region.attribute_21;',
'  l_upload_mechanism p_region.attribute_15%TYPE := p_region.attribute_15;',
'  l_delete_files     p_region.attribute_20%TYPE := p_region.attribute_20;',
'  -- other variables',
'  l_type                VARCHAR2(50);',
'  l_chunked_temp_coll   VARCHAR2(100);',
'  l_blob                BLOB := empty_blob();',
'  l_filename            VARCHAR2(200);',
'  l_mime_type           VARCHAR2(100);',
'  l_delete_id           NUMBER;',
'  l_current_chunk_count NUMBER;',
'  l_total_chunk_count   NUMBER;',
'  --',
'  -- Helper Functions',
'  --',
'',
'  --',
'  -- Write Error JSON',
'  PROCEDURE write_htp_error(p_message IN VARCHAR2,',
'                            p_id      IN VARCHAR2 := NULL) IS',
'  BEGIN',
'    htp.init;',
'    htp.p(''{ "status": "error", "message": "'' ||',
'          apex_escape.json(p_message) || ''", "code": "'' ||',
'          apex_escape.json(SQLERRM) || ''", "id": "'' ||',
'          apex_escape.json(p_id) || ''" }'');',
'  END write_htp_error;',
'  --',
'  -- Write Success JSON',
'  PROCEDURE write_htp_success(p_message IN VARCHAR2,',
'                              p_id      IN VARCHAR2 := NULL) IS',
'  BEGIN',
'    htp.init;',
'    htp.p(''{ "status": "success", "message": "'' ||',
'          apex_escape.json(p_message) || ''", "code": "", "id": "'' ||',
'          apex_escape.json(p_id) || ''" }'');',
'  END write_htp_success;',
'  --',
'  -- Sleep/Pause for given seconds',
'  PROCEDURE sleep(p_seconds IN NUMBER) AS',
'    l_now      TIMESTAMP := systimestamp;',
'    l_end_time TIMESTAMP;',
'  BEGIN',
'    l_end_time := l_now + numtodsinterval(p_seconds,',
'                                          ''second'');',
'  ',
'    WHILE (l_end_time > l_now) LOOP',
'      l_now := systimestamp;',
'    END LOOP;',
'  END sleep;',
'  --',
'  -- base64 array (f01 30k) to blob',
'  FUNCTION base64array_to_blob(p_f01_array IN apex_application.g_f01%TYPE)',
'    RETURN BLOB IS',
'    l_token VARCHAR2(32000);',
'    l_blob  BLOB := empty_blob();',
'  BEGIN',
'    -- build BLOB from f01 30k Array (base64 encoded)',
'    dbms_lob.createtemporary(l_blob,',
'                             FALSE,',
'                             dbms_lob.session);',
'    FOR i IN 1 .. p_f01_array.count LOOP',
'      l_token := p_f01_array(i);',
'      IF length(l_token) > 0 THEN',
'        dbms_lob.append(l_blob,',
'                        to_blob(utl_encode.base64_decode(utl_raw.cast_to_raw(l_token))));',
'      END IF;',
'    END LOOP;',
'    --',
'    RETURN l_blob;',
'    --',
'  END;',
'  --',
'  -- Chunked File Processing',
'  FUNCTION process_chunked_file(p_table_coll_name     IN VARCHAR2,',
'                                p_filename            IN VARCHAR2,',
'                                p_mime_type           IN VARCHAR2,',
'                                p_current_chunk_count IN NUMBER,',
'                                p_total_chunk_count   IN NUMBER,',
'                                p_chunk_f01_array     IN apex_application.g_f01%TYPE)',
'    RETURN BLOB IS',
'    --',
'    l_chunked_temp_coll VARCHAR2(100);',
'    l_chunk_blob        BLOB := empty_blob();',
'    l_blob              BLOB := empty_blob();',
'    l_chunk_length      NUMBER := 0;',
'    -- cursor for file chunks',
'    CURSOR l_cur_chunk_files IS',
'      SELECT apex_collections.blob001 AS chunk_blob,',
'             apex_collections.n003    AS blob_size',
'        FROM apex_collections',
'       WHERE apex_collections.collection_name = l_chunked_temp_coll',
'         AND apex_collections.c001 = p_filename',
'         AND apex_collections.n002 = p_total_chunk_count',
'       ORDER BY apex_collections.n001;',
'    --',
'  BEGIN',
'    l_chunked_temp_coll := upper(p_table_coll_name) || ''_TEMP'';',
'    -- create chunk collection',
'    IF NOT',
'        apex_collection.collection_exists(p_collection_name => l_chunked_temp_coll) THEN',
'      apex_collection.create_collection(p_collection_name => l_chunked_temp_coll);',
'    END IF;',
'    -- build BLOB from f01 30k Array (base64 encoded chunk)',
'    l_chunk_blob   := base64array_to_blob(p_f01_array => p_chunk_f01_array);',
'    l_chunk_length := dbms_lob.getlength(l_chunk_blob);',
'    --',
'    IF p_total_chunk_count > 1 THEN',
'      --',
'      apex_collection.add_member(p_collection_name => l_chunked_temp_coll,',
'                                 p_c001            => p_filename, -- filename',
'                                 p_c002            => p_mime_type, -- mime_type',
'                                 p_n001            => p_current_chunk_count, -- current count from JS loop',
'                                 p_n002            => p_total_chunk_count, -- total count of all chunks',
'                                 p_n003            => l_chunk_length, -- size of base64 BLOB file chunk',
'                                 p_blob001         => l_chunk_blob); -- BLOB base64 file chunk content',
'    ELSE',
'      l_blob := l_chunk_blob;',
'    END IF;',
'    -- last file chunk peace + chunk count > 1',
'    IF p_current_chunk_count = p_total_chunk_count AND',
'       p_total_chunk_count > 1 THEN',
'      --',
'      dbms_lob.createtemporary(l_blob,',
'                               FALSE,',
'                               dbms_lob.session);',
'      -- loop over all file chunks and build final file',
'      FOR l_rec_chunk_files IN l_cur_chunk_files LOOP',
'        IF l_rec_chunk_files.blob_size IS NOT NULL THEN',
'          dbms_lob.append(l_blob,',
'                          l_rec_chunk_files.chunk_blob);',
'        END IF;',
'      END LOOP;',
'      -- delete all chunks for specific file from collection',
'      FOR l_rec_del_coll IN (SELECT seq_id',
'                               FROM apex_collections',
'                              WHERE apex_collections.collection_name =',
'                                    l_chunked_temp_coll',
'                                AND apex_collections.c001 = p_filename',
'                                AND apex_collections.n002 =',
'                                    p_total_chunk_count) LOOP',
'        apex_collection.delete_member(p_collection_name => l_chunked_temp_coll,',
'                                      p_seq             => l_rec_del_coll.seq_id);',
'      END LOOP;',
'      --',
'    END IF;',
'    -- status return json',
'    write_htp_success(''File Chunk '' || p_current_chunk_count || '' of '' ||',
'                      p_total_chunk_count || '' for '' || p_filename ||',
'                      '' successfully saved to Temp. APEX Collection '' ||',
'                      l_chunked_temp_coll);',
'    --',
'    RETURN l_blob;',
'    --',
'  EXCEPTION',
'    WHEN OTHERS THEN',
'      -- status return json',
'      write_htp_error(''File Chunk '' || p_current_chunk_count || '' of '' ||',
'                      p_total_chunk_count || '' for '' || p_filename ||',
'                      '' NOT saved to Temp. APEX Collection '' ||',
'                      l_chunked_temp_coll);',
'      RAISE;',
'  END process_chunked_file;',
'  --',
'  -- FormData File Processing',
'  FUNCTION process_normal_file(p_filename       IN VARCHAR2,',
'                               p_apex_file_name IN VARCHAR2) RETURN BLOB IS',
'    l_blob BLOB := empty_blob();',
'    CURSOR l_cur_file IS',
'      SELECT aaf.blob_content',
'        FROM apex_application_files aaf',
'       WHERE aaf.name = p_apex_file_name;',
'  BEGIN',
'    OPEN l_cur_file;',
'    FETCH l_cur_file',
'      INTO l_blob;',
'    CLOSE l_cur_file;',
'    --',
'    DELETE FROM apex_application_files aaf',
'     WHERE aaf.name = p_apex_file_name;',
'    --',
'    RETURN l_blob;',
'  EXCEPTION',
'    WHEN OTHERS THEN',
'      -- status return json',
'      write_htp_error(''File Upload could not be processed for '' ||',
'                      p_filename);',
'      RAISE;',
'  END process_normal_file;',
'  --',
'  -- Save File to Collection / Table',
'  PROCEDURE save_file(p_storage_type    IN VARCHAR2,',
'                      p_table_coll_name IN VARCHAR2,',
'                      p_filename        IN VARCHAR2,',
'                      p_mime_type       IN VARCHAR2,',
'                      p_blob            IN OUT NOCOPY BLOB,',
'                      p_pk_column       IN VARCHAR2 := NULL,',
'                      p_filename_column IN VARCHAR2 := NULL,',
'                      p_mimetype_column IN VARCHAR2 := NULL,',
'                      p_blob_column     IN VARCHAR2 := NULL,',
'                      p_date_column     IN VARCHAR2 := NULL) IS',
'    --',
'    l_random_file_id NUMBER;',
'    l_insert_sql     VARCHAR2(32767);',
'    l_insert_id      NUMBER;',
'    l_blob_length    NUMBER := 0;',
'    --',
'  BEGIN',
'    --',
'    l_blob_length := nvl(dbms_lob.getlength(p_blob),',
'                         0);',
'    -- only process if BLOB has data',
'    IF l_blob_length > 0 THEN',
'      -- Save to APEX Collection',
'      IF p_storage_type = ''COLLECTION'' THEN',
'        BEGIN',
'          -- random file id',
'          l_random_file_id := round(dbms_random.value(100000,',
'                                                      99999999));',
'          -- check if collection exist',
'          IF NOT',
'              apex_collection.collection_exists(p_collection_name => p_table_coll_name) THEN',
'            apex_collection.create_collection(p_table_coll_name);',
'          END IF;',
'          -- add collection member',
'          l_insert_id := apex_collection.add_member(p_collection_name => p_table_coll_name,',
'                                                    p_c001            => p_filename, -- filename',
'                                                    p_c002            => p_mime_type, -- mime_type',
'                                                    p_d001            => SYSDATE, -- date created',
'                                                    p_n001            => l_random_file_id, -- random file id',
'                                                    p_blob001         => p_blob); -- BLOB file content',
'          -- status return json',
'          write_htp_success(p_message => ''File '' || p_filename ||',
'                                         '' successfully saved to APEX Collection '' ||',
'                                         p_table_coll_name,',
'                            p_id      => l_insert_id);',
'          --',
'        EXCEPTION',
'          WHEN OTHERS THEN',
'            -- status return json',
'            write_htp_error(''File '' || p_filename ||',
'                            '' NOT saved to APEX Collection '' ||',
'                            p_table_coll_name);',
'            RAISE;',
'        END;',
'        --',
'        -- Save to custom Table',
'      ELSIF p_storage_type = ''TABLE'' THEN',
'        BEGIN',
'          -- dynamic insert statement',
'          -- without optional date column',
'          IF p_date_column IS NULL THEN',
'            l_insert_sql := ''INSERT INTO '' ||',
'                            dbms_assert.sql_object_name(p_table_coll_name) || ''( '' ||',
'                            dbms_assert.simple_sql_name(p_filename_column) || '', '' ||',
'                            dbms_assert.simple_sql_name(p_mimetype_column) || '', '' ||',
'                            dbms_assert.simple_sql_name(p_blob_column) ||',
'                            '') VALUES (:filename_value,:mimetype_value,:blob_value) RETURNING '' ||',
'                            dbms_assert.simple_sql_name(p_pk_column) ||',
'                            '' INTO :pk_value'';',
'            -- execute insert',
'            EXECUTE IMMEDIATE l_insert_sql',
'              USING p_filename, p_mime_type, p_blob',
'              RETURNING INTO l_insert_id;',
'            -- with optional date column',
'          ELSE',
'            l_insert_sql := ''INSERT INTO '' ||',
'                            dbms_assert.sql_object_name(p_table_coll_name) || ''( '' ||',
'                            dbms_assert.simple_sql_name(p_filename_column) || '', '' ||',
'                            dbms_assert.simple_sql_name(p_mimetype_column) || '', '' ||',
'                            dbms_assert.simple_sql_name(p_blob_column) || '', '' ||',
'                            dbms_assert.simple_sql_name(p_date_column) ||',
'                            '') VALUES (:filename_value,:mimetype_value,:blob_value,:date_value) RETURNING '' ||',
'                            dbms_assert.simple_sql_name(p_pk_column) ||',
'                            '' INTO :pk_value'';',
'            -- execute insert',
'            EXECUTE IMMEDIATE l_insert_sql',
'              USING p_filename, p_mime_type, p_blob, SYSDATE',
'              RETURNING INTO l_insert_id;',
'          END IF;',
'          -- status return json',
'          write_htp_success(p_message => ''File '' || p_filename ||',
'                                         '' successfully saved to Custom Table '' ||',
'                                         p_table_coll_name,',
'                            p_id      => l_insert_id);',
'          --',
'        EXCEPTION',
'          WHEN OTHERS THEN',
'            -- status return json',
'            write_htp_error(''File '' || p_filename ||',
'                            '' NOT saved to Custom Table '' ||',
'                            p_table_coll_name);',
'            RAISE;',
'        END;',
'        --',
'      END IF;',
'      -- sleep 0.75 sec',
'      sleep(p_seconds => 75 / 100);',
'      --',
'    END IF;',
'    --',
'  EXCEPTION',
'    WHEN OTHERS THEN',
'      -- sleep 0.75 sec',
'      sleep(p_seconds => 75 / 100);',
'      RAISE;',
'  END save_file;',
'  --',
'  -- Delete File from Collection / Table',
'  PROCEDURE delete_file(p_storage_type    IN VARCHAR2,',
'                        p_table_coll_name IN VARCHAR2,',
'                        p_delete_id       IN NUMBER,',
'                        p_filename        IN VARCHAR2,',
'                        p_pk_column       IN VARCHAR2 := NULL) IS',
'    --',
'    l_delete_sql VARCHAR2(32767);',
'    --',
'  BEGIN',
'    -- Delete from APEX Collection',
'    IF p_storage_type = ''COLLECTION'' THEN',
'      --',
'      BEGIN',
'        -- check if collection exist',
'        IF apex_collection.collection_exists(p_collection_name => p_table_coll_name) THEN',
'          -- delete collection member (only if Seq-ID not null)',
'          IF p_delete_id IS NOT NULL THEN',
'            apex_collection.delete_member(p_collection_name => p_table_coll_name,',
'                                          p_seq             => p_delete_id);',
'            -- status return json',
'            write_htp_success(''File '' || p_filename ||',
'                              '' successfully deleted from APEX Collection '' ||',
'                              p_table_coll_name);',
'          ELSE',
'            -- status return json',
'            write_htp_error(''File-ID missing for File '' || p_filename ||',
'                            ''. NOT deleted from APEX Collection '' ||',
'                            p_table_coll_name);',
'          END IF;',
'        ELSE',
'          -- status return json',
'          write_htp_error(''APEX Collection '' || p_table_coll_name ||',
'                          '' missing for File '' || p_filename);',
'        END IF;',
'        --',
'      EXCEPTION',
'        WHEN OTHERS THEN',
'          -- status return json',
'          write_htp_error(''File '' || p_filename ||',
'                          '' NOT deleted from APEX Collection '' ||',
'                          p_table_coll_name);',
'          RAISE;',
'      END;',
'      --',
'      -- Delete from custom Table',
'    ELSIF p_storage_type = ''TABLE'' THEN',
'      BEGIN',
'        -- dynamic delete statement',
'        IF p_delete_id IS NOT NULL THEN',
'          l_delete_sql := ''DELETE FROM '' ||',
'                          dbms_assert.sql_object_name(p_table_coll_name) ||',
'                          '' WHERE '' ||',
'                          dbms_assert.simple_sql_name(p_pk_column) ||',
'                          '' = :pk_value'';',
'          -- execute delete',
'          EXECUTE IMMEDIATE l_delete_sql',
'            USING p_delete_id;',
'          -- status return json',
'          write_htp_success(''File '' || p_filename ||',
'                            '' successfully deleted from Custom Table '' ||',
'                            p_table_coll_name);',
'        ELSE',
'          -- status return json',
'          write_htp_error(''File-ID missing for File '' || p_filename ||',
'                          ''. NOT deleted from Custom Table '' ||',
'                          p_table_coll_name);',
'        END IF;',
'        --',
'      EXCEPTION',
'        WHEN OTHERS THEN',
'          -- status return json',
'          write_htp_error(''File '' || p_filename ||',
'                          '' NOT deleted from Custom Table '' ||',
'                          p_table_coll_name);',
'          RAISE;',
'      END;',
'    END IF;',
'  END delete_file;',
'  --',
'BEGIN',
'  --',
'  -- Debug Info',
'  apex_debug.info(''Dropzone AJAX Parameter x01: '' ||',
'                  apex_application.g_x01);',
'  apex_debug.info(''Dropzone AJAX Parameter x02: '' ||',
'                  apex_application.g_x02);',
'  apex_debug.info(''Dropzone AJAX Parameter x03: '' ||',
'                  apex_application.g_x03);',
'  apex_debug.info(''Dropzone AJAX Parameter x04: '' ||',
'                  apex_application.g_x04);',
'  apex_debug.info(''Dropzone AJAX Parameter x05: '' ||',
'                  apex_application.g_x05);',
'  --',
'  -- replace substitution strings',
'  l_table_coll_name := apex_plugin_util.replace_substitutions(p_value => l_table_coll_name);',
'  l_filename_column := apex_plugin_util.replace_substitutions(p_value => l_filename_column);',
'  l_mimetype_column := apex_plugin_util.replace_substitutions(p_value => l_mimetype_column);',
'  l_blob_column     := apex_plugin_util.replace_substitutions(p_value => l_blob_column);',
'  l_date_column     := apex_plugin_util.replace_substitutions(p_value => l_date_column);',
'  l_pk_column       := apex_plugin_util.replace_substitutions(p_value => l_pk_column);',
'  -- set general vars',
'  l_type            := nvl(apex_application.g_x01,',
'                           ''UPLOAD'');',
'  l_table_coll_name := upper(l_table_coll_name);',
'  --',
'  --',
'  -- Upload',
'  --',
'  IF l_type = ''UPLOAD'' THEN',
'    -- get defaults from AJAX Process',
'    l_filename  := apex_application.g_x02;',
'    l_mime_type := nvl(apex_application.g_x03,',
'                       ''application/octet-stream'');',
'    --',
'    -- Chunked 1MB file upload / chunks in temp collection (multiple server requests (per file chunk))',
'    IF l_upload_mechanism = ''CHUNKED'' THEN',
'      BEGIN',
'        -- get defaults from AJAX Process',
'        l_current_chunk_count := to_number(apex_application.g_x04);',
'        l_total_chunk_count   := to_number(apex_application.g_x05);',
'        --',
'        l_blob := process_chunked_file(p_table_coll_name     => l_table_coll_name,',
'                                       p_filename            => l_filename,',
'                                       p_mime_type           => l_mime_type,',
'                                       p_current_chunk_count => l_current_chunk_count,',
'                                       p_total_chunk_count   => l_total_chunk_count,',
'                                       p_chunk_f01_array     => apex_application.g_f01);',
'      EXCEPTION',
'        WHEN OTHERS THEN',
'          RETURN NULL;',
'      END;',
'      --',
'      -- formdata file upload',
'    ELSIF l_upload_mechanism = ''NORMAL'' THEN',
'      BEGIN',
'        l_blob := process_normal_file(p_filename       => l_filename,',
'                                      p_apex_file_name => apex_application.g_f01(1));',
'      EXCEPTION',
'        WHEN OTHERS THEN',
'          RETURN NULL;',
'      END;',
'    END IF;',
'    --',
'    -- Save final File',
'    BEGIN',
'      save_file(p_storage_type    => l_storage_type,',
'                p_table_coll_name => l_table_coll_name,',
'                p_filename        => l_filename,',
'                p_mime_type       => l_mime_type,',
'                p_blob            => l_blob,',
'                p_pk_column       => l_pk_column,',
'                p_filename_column => l_filename_column,',
'                p_mimetype_column => l_mimetype_column,',
'                p_blob_column     => l_blob_column,',
'                p_date_column     => l_date_column);',
'    EXCEPTION',
'      WHEN OTHERS THEN',
'        RETURN NULL;',
'    END;',
'  END IF;',
'  --',
'  -- Delete File',
'  --',
'  IF l_type = ''DELETE'' AND l_delete_files = ''true'' THEN',
'    l_filename  := apex_application.g_x02;',
'    l_delete_id := to_number(apex_application.g_x03);',
'    --',
'    BEGIN',
'      delete_file(p_storage_type    => l_storage_type,',
'                  p_table_coll_name => l_table_coll_name,',
'                  p_delete_id       => l_delete_id,',
'                  p_filename        => l_filename,',
'                  p_pk_column       => l_pk_column);',
'    EXCEPTION',
'      WHEN OTHERS THEN',
'        RETURN NULL;',
'    END;',
'  END IF;',
'  --',
'  RETURN l_result;',
'  --',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    -- status return json',
'    write_htp_error(''General Error occured in Dropzone AJAX Function'');',
'    RETURN NULL;',
'END ajax_dropzone;'))
,p_api_version=>1
,p_render_function=>'render_dropzone'
,p_ajax_function=>'ajax_dropzone'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'Dropzone is a region type plugin that allows you to provide nice looking drag’n’drop file uploads. It is based on JS Framework dropzone.js.'
,p_version_identifier=>'2.4.1'
,p_about_url=>'https://github.com/Dani3lSun/apex-plugin-dropzone'
,p_files_version=>1414
);
end;
/
begin
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136373031498822823)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Display Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Drop files here or click to upload.'
,p_is_translatable=>true
,p_help_text=>'Message that is displayed inside of the Dropzone Region'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136373865307826748)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Fallback Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Your browser does not support drag''n''drop file uploads.'
,p_is_translatable=>true
,p_help_text=>'Message that is displayed when your Browser doesn´t support HTML5 Drag & Drop File Uploads'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136374320793832027)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'File too Big Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'File is too big ({{filesize}}MiB). Max filesize: {{maxFilesize}}MiB.'
,p_is_translatable=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Message that is displayed per File, if the File is bigger than you allowed in the settings.<br>',
'You can use Placeholders like:<br>',
'{{filesize}} for the Filesize<br>',
'{{maxFilesize}} for the max. allowed Filesize'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136374826835834437)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'max. Files Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'You can not upload more than {{maxFiles}} files.'
,p_is_translatable=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Message that is displayed per File, if the uploaded Files exceed the max. Files settings.<br>',
'You can use Placeholders like:<br>',
'{{maxFiles}} for the max. allowed Files'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136375346937836729)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Remove File Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Remove file'
,p_is_translatable=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Message that is displayed below a single File to remove the File.<br>',
'Only possible if "Delete Files" is set.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136375876160839531)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Cancel Upload Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Cancel upload'
,p_is_translatable=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Message that is displayed below a single File to Cancel Uploading during the actual Upload Process.<br>',
'Only possible if "Delete Files" is set.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136376310041842498)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Cancel Upload Confirm Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Are you sure you want to cancel this upload?'
,p_is_translatable=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Message that is displayed in the Confirm Dialog if you clicked the Upload Cancel Link.<br>',
'Only possible if "Delete Files" is set.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136376889840846218)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Invalid File Type Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'You can not upload files of this type.'
,p_is_translatable=>true
,p_help_text=>'Message that is displayed per File, if the File´s Mime-Type is in the Exclude List.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(81266287492138158)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Chunk Size (in KB)'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'1048576'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This is the default chunk size if you choose the Chunked upload mechanism. The file is split into pieces of that size. Each piece is sent to the server separately.<br>',
'Thus the files are base64 encoded, there is a little overhead in the file size, so please consider a plus of about 10-15% in file size.<br>',
'Default is 1MB = 1048576 KB.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136378105370922737)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Storage Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'COLLECTION'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'SELECT c001    AS filename,',
'       c002    AS mime_type,',
'       d001    AS date_created,',
'       n001    AS file_id,',
'       blob001 AS file_content',
'  FROM apex_collections',
' WHERE collection_name = ''DROPZONE_UPLOAD'';',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Choose where the uploaded files are saved.<br>',
'You can either save your files to a APEX Collection or to a Custom Table.<br><br>',
'<strong>APEX Collection</strong><br>',
'The APEX collection way should be the easiest. You only have to enter a Collection Name. After that you can Select the files from APEX_COLLECTIONS View.<br><br>',
'Default Collection "DROPZONE_UPLOAD".<br>',
'Column c001 => filename<br>',
'Column c002 => mime_type<br>',
'Column d001 => date created<br>',
'Column n001 => random file id<br>',
'Column blob001 => BLOB of file<br><br>',
'<strong>Custom Table</strong><br>',
'A Table must have Columns for Filename, Mime Type and the File Content (BLOB). The Primary Key (PK) must be processed with a Before Insert Trigger. Optionally the table can have a date column to save the upload date.<br>',
'If your table has other required columns you have to insert these values via Database Trigger or something like that.'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136378610283923777)
,p_plugin_attribute_id=>wwv_flow_api.id(136378105370922737)
,p_display_sequence=>10
,p_display_value=>'APEX Collection'
,p_return_value=>'COLLECTION'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136379072998925076)
,p_plugin_attribute_id=>wwv_flow_api.id(136378105370922737)
,p_display_sequence=>20
,p_display_value=>'Custom Table'
,p_return_value=>'TABLE'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136372454005805126)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Collection / Table Name'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'DROPZONE_UPLOAD'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(136378105370922737)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'COLLECTION,TABLE'
,p_help_text=>'Name of the APEX Collection or of your Custom Table'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136382269650943192)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Filename Column'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(136378105370922737)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'TABLE'
,p_help_text=>'Column of your custom Table which holds the information for the Filename'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136382754155946895)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Mime Type Column'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(136378105370922737)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'TABLE'
,p_help_text=>'Column of your custom Table which holds the information for the File Mime-Type'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136383281947956680)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'BLOB Column'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(136378105370922737)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'TABLE'
,p_help_text=>'Column of your custom Table which holds the information for the File Content (BLOB)'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136383770254960168)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Date Column'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(136378105370922737)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'TABLE'
,p_help_text=>'Column of your custom Table which holds the information for the File Upload Date'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136323388362859791)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Dropzone Style'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'STYLE1'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UI Style of your Dropzone Region<br>',
'- Grey Border<br>',
'- Blue Dashed Border<br>',
'- Red Dashed Border<br>',
'- Grey Dashed Border/Background'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136323787004859791)
,p_plugin_attribute_id=>wwv_flow_api.id(136323388362859791)
,p_display_sequence=>10
,p_display_value=>'Grey Border'
,p_return_value=>'STYLE1'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136324302174859791)
,p_plugin_attribute_id=>wwv_flow_api.id(136323388362859791)
,p_display_sequence=>20
,p_display_value=>'Blue Dashed Border'
,p_return_value=>'STYLE2'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136511784051684955)
,p_plugin_attribute_id=>wwv_flow_api.id(136323388362859791)
,p_display_sequence=>30
,p_display_value=>'Red Dashed Border'
,p_return_value=>'STYLE3'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136728633382856635)
,p_plugin_attribute_id=>wwv_flow_api.id(136323388362859791)
,p_display_sequence=>40
,p_display_value=>'Grey Dashed Border/Background'
,p_return_value=>'STYLE4'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136311129209859788)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Width'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'700px'
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'700px<br>',
'100%'))
,p_help_text=>'Enter the default width of your Dropzone Region. Valid values are px and % data.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136311587089859788)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Height'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'400px'
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'400px<br>',
'500px'))
,p_help_text=>'Enter the default height of Dropzone Region. Valid values in px.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136312340197859788)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'max. Filesize in MB'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'2'
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'1<br>',
'2<br>',
'3.5'))
,p_help_text=>'max. File Size (Float Number) that is allowed per file. If a file is larger, it will be removed.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136318914821859789)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'max. Files'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Maximum number of allowed files that can be uploaded at once.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136321554670859791)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Parallel Uploads [NOT USED]'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'1'
,p_max_length=>1
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(136378105370922737)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'NEVER'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Number of parallel Upload Streams to the server.<br>',
'Choose a value between 1 and 2. 1 works most reliable!'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136317741879859789)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Accepted File Types'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_examples=>'image/*,application/pdf,.psd'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'If you only want that users can upload Files of declared types.<br>',
'Default: all file types are allowed<br>',
'Valid values: comma separated list of Mime-Types (with Wildcard support) or File endings: image/*,application/pdf,.psd'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136321105715859790)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Wait Time (ms) [NOT USED]'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'700'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(136378105370922737)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'NEVER'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Wait time between several uploaded files in milliseconds.<br>',
'In some environments Dropzone is faster than storing files in Database.<br>',
'Default: 700ms'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136396730349039142)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>65
,p_prompt=>'Upload Mechanism'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'NORMAL'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><strong>Normal:</strong> Files are directly uploaded to the DB using a multipart/form-data POST (FormData) request. This method needs no conversion (decode, encode) of strings, thus the final BLOB is already there and can be used.</p>',
'<p><strong>Chunked:</strong> Files are split into chunks (default: 1MB), then each chunk is encoded into base64. This encoded string is then uploaded to the DB, the DB decodes the encoded chunks and builds a final BLOB out of it.</p>',
'<p>Both methods should work with all web server combinations. Thus no conversion is needed for "normal" uploads, this method is 2x as fast as "chunked". If, somehow, your web server configuration allows no large multipart/form-data requests, go with '
||'the "chunked" method.<p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136397266879051298)
,p_plugin_attribute_id=>wwv_flow_api.id(136396730349039142)
,p_display_sequence=>10
,p_display_value=>'Normal'
,p_return_value=>'NORMAL'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136397653321052575)
,p_plugin_attribute_id=>wwv_flow_api.id(136396730349039142)
,p_display_sequence=>20
,p_display_value=>'Chunked'
,p_return_value=>'CHUNKED'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136312757390859788)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>16
,p_display_sequence=>160
,p_prompt=>'Clickable'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'true'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'If true, the Dropzone Region will be clickable, if false nothing will be clickable and only Drag & Drop is possible.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136313142868859788)
,p_plugin_attribute_id=>wwv_flow_api.id(136312757390859788)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136313681853859788)
,p_plugin_attribute_id=>wwv_flow_api.id(136312757390859788)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136321990264859791)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>17
,p_display_sequence=>170
,p_prompt=>'Show File Previews'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'true'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Show Preview Images for common File types when adding files.<br>',
'Images got displayed with real content.<br>',
'If you want to add more images or others just Copy/Upload the PNG Files to "img" directory. Naming: <file-extension>.png'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136322365682859791)
,p_plugin_attribute_id=>wwv_flow_api.id(136321990264859791)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136322820894859791)
,p_plugin_attribute_id=>wwv_flow_api.id(136321990264859791)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136319722966859790)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>18
,p_display_sequence=>180
,p_prompt=>'Copy & Paste Support'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'false'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'1) Open Image File<br>',
'2) Copy File (Strg+C or Cmd+C)<br>',
'3) Paste it to the page which contains the Dropzone Region in your Browser (Strg+V or Cmd+V)'))
,p_help_text=>'Adds support for Copy & Paste of Images in modern Browsers (like Chrome or Firefox > 50).<br>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136320151655859790)
,p_plugin_attribute_id=>wwv_flow_api.id(136319722966859790)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136320702298859790)
,p_plugin_attribute_id=>wwv_flow_api.id(136319722966859790)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136316323799859789)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>19
,p_display_sequence=>190
,p_prompt=>'Remove Files after Upload'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'false'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'If true, clears all Files from Dropzone Region after uploading has finished.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136316733164859789)
,p_plugin_attribute_id=>wwv_flow_api.id(136316323799859789)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136317279708859789)
,p_plugin_attribute_id=>wwv_flow_api.id(136316323799859789)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136326508352859792)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>20
,p_display_sequence=>67
,p_prompt=>'Delete Files'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'false'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Possibility for end users to delete each file that was uploaded to the server.<br>',
'Only if no Page Refresh has occurred.'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136326964024859792)
,p_plugin_attribute_id=>wwv_flow_api.id(136326508352859792)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(136327478677859792)
,p_plugin_attribute_id=>wwv_flow_api.id(136326508352859792)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(136736151856133069)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>21
,p_display_sequence=>55
,p_prompt=>'PK Column'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(136378105370922737)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'TABLE'
,p_help_text=>'Primary Key (PK) Column of your custom file Table'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(81234328010866918)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>22
,p_display_sequence=>200
,p_prompt=>'Image Resizing'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'false'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'If true, images are resized to a specified size. This happens on client side before uploading the file to server. Saving upload bandwidth and reducing upload time.<br>',
'Please set at least one resize attribute, e.g. Resize Width or Resize Height.'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(81235143689867435)
,p_plugin_attribute_id=>wwv_flow_api.id(81234328010866918)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(81235557928868084)
,p_plugin_attribute_id=>wwv_flow_api.id(81234328010866918)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(81236335729873339)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>23
,p_display_sequence=>230
,p_prompt=>'Resize Width'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(81234328010866918)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'true'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'If set, images will be resized to these dimensions before being uploaded. If only one, resize Width or resize Height is provided, the original aspect ratio of the file will be preserved.<br>',
'Please provide a width in pixels.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(81237080022875540)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>24
,p_display_sequence=>240
,p_prompt=>'Resize Height'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(81234328010866918)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'true'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'If set, images will be resized to these dimensions before being uploaded. If only one, resize Width or resize Height is provided, the original aspect ratio of the file will be preserved.<br>',
'Please provide a height in pixels.'))
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136330935434859793)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-added-file'
,p_display_name=>'Dropzone File added'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136331373469859793)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-delete-error'
,p_display_name=>'Dropzone File Delete Error (AJAX)'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136331735618859793)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-delete-success'
,p_display_name=>'Dropzone File Delete Success (AJAX)'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136476667754541850)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-deleted-file'
,p_display_name=>'Dropzone File deleted'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136733618617900997)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-drag-over'
,p_display_name=>'Dropzone Dragging File over Region'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136733273361900997)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-file-error'
,p_display_name=>'Dropzone File Error'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136332153815859794)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-maxfiles-exceeded'
,p_display_name=>'Dropzone max Files exceeded'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136476952902541851)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-totalupload-progress'
,p_display_name=>'Dropzone Total Upload Progress'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136477789431541851)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-upload-chunk-error'
,p_display_name=>'Dropzone Chunked File Upload Error (AJAX)'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136477360978541851)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-upload-chunk-success'
,p_display_name=>'Dropzone Chunked File Upload Success (AJAX)'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136332600151859794)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-upload-complete'
,p_display_name=>'Dropzone Upload completed'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136332924541859795)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-upload-error'
,p_display_name=>'Dropzone File Upload Error (AJAX)'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(136333381663859795)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_name=>'dropzone-upload-success'
,p_display_name=>'Dropzone File Upload Success (AJAX)'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A415045582044726F707A6F6E65204353530A417574686F723A2044616E69656C20486F63686C6569746E65720A56657273696F6E3A20322E342E310A2A2F0A0A2E647A2D6D657373616765207B0A20202020666F6E742D73697A653A20312E3465';
wwv_flow_api.g_varchar2_table(2) := '6D3B0A20202020666F6E742D7765696768743A203430303B0A7D0A0A2E64726F707A6F6E65202E647A2D707265766965772E647A2D696D6167652D70726576696577207B0A202020206261636B67726F756E643A206E6F6E653B0A7D0A0A2E647A2D7374';
wwv_flow_api.g_varchar2_table(3) := '796C6531207B0A20202020626F726465723A2035707820736F6C696420677265793B0A202020206261636B67726F756E643A2077686974653B0A202020206F766572666C6F773A206175746F3B0A7D0A0A2E647A2D7374796C6532207B0A20202020626F';
wwv_flow_api.g_varchar2_table(4) := '726465723A203370782064617368656420233030383746373B0A20202020626F726465722D7261646975733A203570783B0A202020206261636B67726F756E643A2077686974653B0A202020206F766572666C6F773A206175746F3B0A7D0A0A2E647A2D';
wwv_flow_api.g_varchar2_table(5) := '7374796C6533207B0A20202020626F726465723A203370782064617368656420236666303032363B0A20202020626F726465722D7261646975733A203570783B0A202020206261636B67726F756E643A2077686974653B0A202020206F766572666C6F77';
wwv_flow_api.g_varchar2_table(6) := '3A206175746F3B0A7D0A0A2E647A2D7374796C6534207B0A20202020626F726465723A203270782064617368656420233845384539333B0A20202020626F726465722D7261646975733A20313070783B0A202020206261636B67726F756E642D636F6C6F';
wwv_flow_api.g_varchar2_table(7) := '723A207267626128302C20302C20302C20302E31293B0A20202020636F6C6F723A20233730373037303B0A202020206F766572666C6F773A206175746F3B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72338199194797125)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'css/apexdropzone.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E647A2D6D6573736167657B666F6E742D73697A653A312E34656D3B666F6E742D7765696768743A3430307D2E64726F707A6F6E65202E647A2D707265766965772E647A2D696D6167652D707265766965777B6261636B67726F756E643A3020307D2E64';
wwv_flow_api.g_varchar2_table(2) := '7A2D7374796C65312C2E647A2D7374796C65322C2E647A2D7374796C65337B626F726465723A35707820736F6C696420677261793B6261636B67726F756E643A236666663B6F766572666C6F773A6175746F7D2E647A2D7374796C65322C2E647A2D7374';
wwv_flow_api.g_varchar2_table(3) := '796C65337B626F726465723A3370782064617368656420233030383766373B626F726465722D7261646975733A3570787D2E647A2D7374796C65337B626F726465723A3370782064617368656420236666303032367D2E647A2D7374796C65347B626F72';
wwv_flow_api.g_varchar2_table(4) := '6465723A3270782064617368656420233865386539333B626F726465722D7261646975733A313070783B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E31293B636F6C6F723A233730373037303B6F766572666C6F773A617574';
wwv_flow_api.g_varchar2_table(5) := '6F7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72338535324797126)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'css/apexdropzone.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A202A20546865204D4954204C6963656E73650A202A20436F70797269676874202863292032303132204D6174696173204D656E6F203C6D40746961732E6D653E0A202A2F0A402D7765626B69742D6B65796672616D65732070617373696E672D74';
wwv_flow_api.g_varchar2_table(2) := '68726F756768207B0A20203025207B0A202020206F7061636974793A20303B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C61';
wwv_flow_api.g_varchar2_table(3) := '7465592834307078293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020207472616E73666F726D3A2074';
wwv_flow_api.g_varchar2_table(4) := '72616E736C617465592834307078293B207D0A20203330252C20373025207B0A202020206F7061636974793A20313B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6D6F7A2D747261';
wwv_flow_api.g_varchar2_table(5) := '6E73666F726D3A207472616E736C6174655928307078293B0A202020202D6D732D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C6174655928307078293B0A20202020';
wwv_flow_api.g_varchar2_table(6) := '7472616E73666F726D3A207472616E736C6174655928307078293B207D0A202031303025207B0A202020206F7061636974793A20303B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C61746559282D34307078293B0A202020';
wwv_flow_api.g_varchar2_table(7) := '202D6D6F7A2D7472616E73666F726D3A207472616E736C61746559282D34307078293B0A202020202D6D732D7472616E73666F726D3A207472616E736C61746559282D34307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C6174';
wwv_flow_api.g_varchar2_table(8) := '6559282D34307078293B0A202020207472616E73666F726D3A207472616E736C61746559282D34307078293B207D207D0A402D6D6F7A2D6B65796672616D65732070617373696E672D7468726F756768207B0A20203025207B0A202020206F7061636974';
wwv_flow_api.g_varchar2_table(9) := '793A20303B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6D732D7472616E73666F';
wwv_flow_api.g_varchar2_table(10) := '726D3A207472616E736C617465592834307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020207472616E73666F726D3A207472616E736C617465592834307078293B207D0A20203330252C20';
wwv_flow_api.g_varchar2_table(11) := '373025207B0A202020206F7061636974793A20313B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C6174655928307078293B0A20';
wwv_flow_api.g_varchar2_table(12) := '2020202D6D732D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020207472616E73666F726D3A207472616E736C617465592830707829';
wwv_flow_api.g_varchar2_table(13) := '3B207D0A202031303025207B0A202020206F7061636974793A20303B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C61746559282D34307078293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465';
wwv_flow_api.g_varchar2_table(14) := '59282D34307078293B0A202020202D6D732D7472616E73666F726D3A207472616E736C61746559282D34307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C61746559282D34307078293B0A202020207472616E73666F726D3A20';
wwv_flow_api.g_varchar2_table(15) := '7472616E736C61746559282D34307078293B207D207D0A406B65796672616D65732070617373696E672D7468726F756768207B0A20203025207B0A202020206F7061636974793A20303B0A202020202D7765626B69742D7472616E73666F726D3A207472';
wwv_flow_api.g_varchar2_table(16) := '616E736C617465592834307078293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6F2D7472';
wwv_flow_api.g_varchar2_table(17) := '616E73666F726D3A207472616E736C617465592834307078293B0A202020207472616E73666F726D3A207472616E736C617465592834307078293B207D0A20203330252C20373025207B0A202020206F7061636974793A20313B0A202020202D7765626B';
wwv_flow_api.g_varchar2_table(18) := '69742D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6D732D7472616E73666F726D3A207472616E736C61746559283070';
wwv_flow_api.g_varchar2_table(19) := '78293B0A202020202D6F2D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020207472616E73666F726D3A207472616E736C6174655928307078293B207D0A202031303025207B0A202020206F7061636974793A20303B0A2020';
wwv_flow_api.g_varchar2_table(20) := '20202D7765626B69742D7472616E73666F726D3A207472616E736C61746559282D34307078293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C61746559282D34307078293B0A202020202D6D732D7472616E73666F726D3A207472';
wwv_flow_api.g_varchar2_table(21) := '616E736C61746559282D34307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C61746559282D34307078293B0A202020207472616E73666F726D3A207472616E736C61746559282D34307078293B207D207D0A402D7765626B6974';
wwv_flow_api.g_varchar2_table(22) := '2D6B65796672616D657320736C6964652D696E207B0A20203025207B0A202020206F7061636974793A20303B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6D6F7A2D7472616E73';
wwv_flow_api.g_varchar2_table(23) := '666F726D3A207472616E736C617465592834307078293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020';
wwv_flow_api.g_varchar2_table(24) := '207472616E73666F726D3A207472616E736C617465592834307078293B207D0A2020333025207B0A202020206F7061636974793A20313B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C6174655928307078293B0A20202020';
wwv_flow_api.g_varchar2_table(25) := '2D6D6F7A2D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6D732D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C61746559283070';
wwv_flow_api.g_varchar2_table(26) := '78293B0A202020207472616E73666F726D3A207472616E736C6174655928307078293B207D207D0A402D6D6F7A2D6B65796672616D657320736C6964652D696E207B0A20203025207B0A202020206F7061636974793A20303B0A202020202D7765626B69';
wwv_flow_api.g_varchar2_table(27) := '742D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465592834';
wwv_flow_api.g_varchar2_table(28) := '307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020207472616E73666F726D3A207472616E736C617465592834307078293B207D0A2020333025207B0A202020206F7061636974793A20313B';
wwv_flow_api.g_varchar2_table(29) := '0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6D732D7472616E73666F726D3A20747261';
wwv_flow_api.g_varchar2_table(30) := '6E736C6174655928307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020207472616E73666F726D3A207472616E736C6174655928307078293B207D207D0A406B65796672616D657320736C6964';
wwv_flow_api.g_varchar2_table(31) := '652D696E207B0A20203025207B0A202020206F7061636974793A20303B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465';
wwv_flow_api.g_varchar2_table(32) := '592834307078293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465592834307078293B0A202020207472616E73666F726D3A20747261';
wwv_flow_api.g_varchar2_table(33) := '6E736C617465592834307078293B207D0A2020333025207B0A202020206F7061636974793A20313B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6D6F7A2D7472616E73666F726D3A';
wwv_flow_api.g_varchar2_table(34) := '207472616E736C6174655928307078293B0A202020202D6D732D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020202D6F2D7472616E73666F726D3A207472616E736C6174655928307078293B0A202020207472616E73666F';
wwv_flow_api.g_varchar2_table(35) := '726D3A207472616E736C6174655928307078293B207D207D0A402D7765626B69742D6B65796672616D65732070756C7365207B0A20203025207B0A202020202D7765626B69742D7472616E73666F726D3A207363616C652831293B0A202020202D6D6F7A';
wwv_flow_api.g_varchar2_table(36) := '2D7472616E73666F726D3A207363616C652831293B0A202020202D6D732D7472616E73666F726D3A207363616C652831293B0A202020202D6F2D7472616E73666F726D3A207363616C652831293B0A202020207472616E73666F726D3A207363616C6528';
wwv_flow_api.g_varchar2_table(37) := '31293B207D0A2020313025207B0A202020202D7765626B69742D7472616E73666F726D3A207363616C6528312E31293B0A202020202D6D6F7A2D7472616E73666F726D3A207363616C6528312E31293B0A202020202D6D732D7472616E73666F726D3A20';
wwv_flow_api.g_varchar2_table(38) := '7363616C6528312E31293B0A202020202D6F2D7472616E73666F726D3A207363616C6528312E31293B0A202020207472616E73666F726D3A207363616C6528312E31293B207D0A2020323025207B0A202020202D7765626B69742D7472616E73666F726D';
wwv_flow_api.g_varchar2_table(39) := '3A207363616C652831293B0A202020202D6D6F7A2D7472616E73666F726D3A207363616C652831293B0A202020202D6D732D7472616E73666F726D3A207363616C652831293B0A202020202D6F2D7472616E73666F726D3A207363616C652831293B0A20';
wwv_flow_api.g_varchar2_table(40) := '2020207472616E73666F726D3A207363616C652831293B207D207D0A402D6D6F7A2D6B65796672616D65732070756C7365207B0A20203025207B0A202020202D7765626B69742D7472616E73666F726D3A207363616C652831293B0A202020202D6D6F7A';
wwv_flow_api.g_varchar2_table(41) := '2D7472616E73666F726D3A207363616C652831293B0A202020202D6D732D7472616E73666F726D3A207363616C652831293B0A202020202D6F2D7472616E73666F726D3A207363616C652831293B0A202020207472616E73666F726D3A207363616C6528';
wwv_flow_api.g_varchar2_table(42) := '31293B207D0A2020313025207B0A202020202D7765626B69742D7472616E73666F726D3A207363616C6528312E31293B0A202020202D6D6F7A2D7472616E73666F726D3A207363616C6528312E31293B0A202020202D6D732D7472616E73666F726D3A20';
wwv_flow_api.g_varchar2_table(43) := '7363616C6528312E31293B0A202020202D6F2D7472616E73666F726D3A207363616C6528312E31293B0A202020207472616E73666F726D3A207363616C6528312E31293B207D0A2020323025207B0A202020202D7765626B69742D7472616E73666F726D';
wwv_flow_api.g_varchar2_table(44) := '3A207363616C652831293B0A202020202D6D6F7A2D7472616E73666F726D3A207363616C652831293B0A202020202D6D732D7472616E73666F726D3A207363616C652831293B0A202020202D6F2D7472616E73666F726D3A207363616C652831293B0A20';
wwv_flow_api.g_varchar2_table(45) := '2020207472616E73666F726D3A207363616C652831293B207D207D0A406B65796672616D65732070756C7365207B0A20203025207B0A202020202D7765626B69742D7472616E73666F726D3A207363616C652831293B0A202020202D6D6F7A2D7472616E';
wwv_flow_api.g_varchar2_table(46) := '73666F726D3A207363616C652831293B0A202020202D6D732D7472616E73666F726D3A207363616C652831293B0A202020202D6F2D7472616E73666F726D3A207363616C652831293B0A202020207472616E73666F726D3A207363616C652831293B207D';
wwv_flow_api.g_varchar2_table(47) := '0A2020313025207B0A202020202D7765626B69742D7472616E73666F726D3A207363616C6528312E31293B0A202020202D6D6F7A2D7472616E73666F726D3A207363616C6528312E31293B0A202020202D6D732D7472616E73666F726D3A207363616C65';
wwv_flow_api.g_varchar2_table(48) := '28312E31293B0A202020202D6F2D7472616E73666F726D3A207363616C6528312E31293B0A202020207472616E73666F726D3A207363616C6528312E31293B207D0A2020323025207B0A202020202D7765626B69742D7472616E73666F726D3A20736361';
wwv_flow_api.g_varchar2_table(49) := '6C652831293B0A202020202D6D6F7A2D7472616E73666F726D3A207363616C652831293B0A202020202D6D732D7472616E73666F726D3A207363616C652831293B0A202020202D6F2D7472616E73666F726D3A207363616C652831293B0A202020207472';
wwv_flow_api.g_varchar2_table(50) := '616E73666F726D3A207363616C652831293B207D207D0A2E64726F707A6F6E652C202E64726F707A6F6E65202A207B0A2020626F782D73697A696E673A20626F726465722D626F783B207D0A0A2E64726F707A6F6E65207B0A20206D696E2D6865696768';
wwv_flow_api.g_varchar2_table(51) := '743A2031353070783B0A2020626F726465723A2032707820736F6C6964207267626128302C20302C20302C20302E33293B0A20206261636B67726F756E643A2077686974653B0A202070616464696E673A203230707820323070783B207D0A20202E6472';
wwv_flow_api.g_varchar2_table(52) := '6F707A6F6E652E647A2D636C69636B61626C65207B0A20202020637572736F723A20706F696E7465723B207D0A202020202E64726F707A6F6E652E647A2D636C69636B61626C65202A207B0A202020202020637572736F723A2064656661756C743B207D';
wwv_flow_api.g_varchar2_table(53) := '0A202020202E64726F707A6F6E652E647A2D636C69636B61626C65202E647A2D6D6573736167652C202E64726F707A6F6E652E647A2D636C69636B61626C65202E647A2D6D657373616765202A207B0A202020202020637572736F723A20706F696E7465';
wwv_flow_api.g_varchar2_table(54) := '723B207D0A20202E64726F707A6F6E652E647A2D73746172746564202E647A2D6D657373616765207B0A20202020646973706C61793A206E6F6E653B207D0A20202E64726F707A6F6E652E647A2D647261672D686F766572207B0A20202020626F726465';
wwv_flow_api.g_varchar2_table(55) := '722D7374796C653A20736F6C69643B207D0A202020202E64726F707A6F6E652E647A2D647261672D686F766572202E647A2D6D657373616765207B0A2020202020206F7061636974793A20302E353B207D0A20202E64726F707A6F6E65202E647A2D6D65';
wwv_flow_api.g_varchar2_table(56) := '7373616765207B0A20202020746578742D616C69676E3A2063656E7465723B0A202020206D617267696E3A2032656D20303B207D0A20202E64726F707A6F6E65202E647A2D70726576696577207B0A20202020706F736974696F6E3A2072656C61746976';
wwv_flow_api.g_varchar2_table(57) := '653B0A20202020646973706C61793A20696E6C696E652D626C6F636B3B0A20202020766572746963616C2D616C69676E3A20746F703B0A202020206D617267696E3A20313670783B0A202020206D696E2D6865696768743A2031303070783B207D0A2020';
wwv_flow_api.g_varchar2_table(58) := '20202E64726F707A6F6E65202E647A2D707265766965773A686F766572207B0A2020202020207A2D696E6465783A20313030303B207D0A2020202020202E64726F707A6F6E65202E647A2D707265766965773A686F766572202E647A2D64657461696C73';
wwv_flow_api.g_varchar2_table(59) := '207B0A20202020202020206F7061636974793A20313B207D0A202020202E64726F707A6F6E65202E647A2D707265766965772E647A2D66696C652D70726576696577202E647A2D696D616765207B0A202020202020626F726465722D7261646975733A20';
wwv_flow_api.g_varchar2_table(60) := '323070783B0A2020202020206261636B67726F756E643A20233939393B0A2020202020206261636B67726F756E643A206C696E6561722D6772616469656E7428746F20626F74746F6D2C20236565652C2023646464293B207D0A202020202E64726F707A';
wwv_flow_api.g_varchar2_table(61) := '6F6E65202E647A2D707265766965772E647A2D66696C652D70726576696577202E647A2D64657461696C73207B0A2020202020206F7061636974793A20313B207D0A202020202E64726F707A6F6E65202E647A2D707265766965772E647A2D696D616765';
wwv_flow_api.g_varchar2_table(62) := '2D70726576696577207B0A2020202020206261636B67726F756E643A2077686974653B207D0A2020202020202E64726F707A6F6E65202E647A2D707265766965772E647A2D696D6167652D70726576696577202E647A2D64657461696C73207B0A202020';
wwv_flow_api.g_varchar2_table(63) := '20202020202D7765626B69742D7472616E736974696F6E3A206F70616369747920302E3273206C696E6561723B0A20202020202020202D6D6F7A2D7472616E736974696F6E3A206F70616369747920302E3273206C696E6561723B0A2020202020202020';
wwv_flow_api.g_varchar2_table(64) := '2D6D732D7472616E736974696F6E3A206F70616369747920302E3273206C696E6561723B0A20202020202020202D6F2D7472616E736974696F6E3A206F70616369747920302E3273206C696E6561723B0A20202020202020207472616E736974696F6E3A';
wwv_flow_api.g_varchar2_table(65) := '206F70616369747920302E3273206C696E6561723B207D0A202020202E64726F707A6F6E65202E647A2D70726576696577202E647A2D72656D6F7665207B0A202020202020666F6E742D73697A653A20313470783B0A202020202020746578742D616C69';
wwv_flow_api.g_varchar2_table(66) := '676E3A2063656E7465723B0A202020202020646973706C61793A20626C6F636B3B0A202020202020637572736F723A20706F696E7465723B0A202020202020626F726465723A206E6F6E653B207D0A2020202020202E64726F707A6F6E65202E647A2D70';
wwv_flow_api.g_varchar2_table(67) := '726576696577202E647A2D72656D6F76653A686F766572207B0A2020202020202020746578742D6465636F726174696F6E3A20756E6465726C696E653B207D0A202020202E64726F707A6F6E65202E647A2D707265766965773A686F766572202E647A2D';
wwv_flow_api.g_varchar2_table(68) := '64657461696C73207B0A2020202020206F7061636974793A20313B207D0A202020202E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73207B0A2020202020207A2D696E6465783A2032303B0A202020202020706F736974';
wwv_flow_api.g_varchar2_table(69) := '696F6E3A206162736F6C7574653B0A202020202020746F703A20303B0A2020202020206C6566743A20303B0A2020202020206F7061636974793A20303B0A202020202020666F6E742D73697A653A20313370783B0A2020202020206D696E2D7769647468';
wwv_flow_api.g_varchar2_table(70) := '3A20313030253B0A2020202020206D61782D77696474683A20313030253B0A20202020202070616464696E673A2032656D2031656D3B0A202020202020746578742D616C69676E3A2063656E7465723B0A202020202020636F6C6F723A20726762612830';
wwv_flow_api.g_varchar2_table(71) := '2C20302C20302C20302E39293B0A2020202020206C696E652D6865696768743A20313530253B207D0A2020202020202E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73202E647A2D73697A65207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(72) := '6D617267696E2D626F74746F6D3A2031656D3B0A2020202020202020666F6E742D73697A653A20313670783B207D0A2020202020202E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73202E647A2D66696C656E616D6520';
wwv_flow_api.g_varchar2_table(73) := '7B0A202020202020202077686974652D73706163653A206E6F777261703B207D0A20202020202020202E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73202E647A2D66696C656E616D653A686F766572207370616E207B';
wwv_flow_api.g_varchar2_table(74) := '0A20202020202020202020626F726465723A2031707820736F6C69642072676261283230302C203230302C203230302C20302E38293B0A202020202020202020206261636B67726F756E642D636F6C6F723A2072676261283235352C203235352C203235';
wwv_flow_api.g_varchar2_table(75) := '352C20302E38293B207D0A20202020202020202E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73202E647A2D66696C656E616D653A6E6F74283A686F76657229207B0A202020202020202020206F766572666C6F773A20';
wwv_flow_api.g_varchar2_table(76) := '68696464656E3B0A20202020202020202020746578742D6F766572666C6F773A20656C6C69707369733B207D0A202020202020202020202E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73202E647A2D66696C656E616D';
wwv_flow_api.g_varchar2_table(77) := '653A6E6F74283A686F76657229207370616E207B0A202020202020202020202020626F726465723A2031707820736F6C6964207472616E73706172656E743B207D0A2020202020202E64726F707A6F6E65202E647A2D70726576696577202E647A2D6465';
wwv_flow_api.g_varchar2_table(78) := '7461696C73202E647A2D66696C656E616D65207370616E2C202E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73202E647A2D73697A65207370616E207B0A20202020202020206261636B67726F756E642D636F6C6F723A';
wwv_flow_api.g_varchar2_table(79) := '2072676261283235352C203235352C203235352C20302E34293B0A202020202020202070616464696E673A203020302E34656D3B0A2020202020202020626F726465722D7261646975733A203370783B207D0A202020202E64726F707A6F6E65202E647A';
wwv_flow_api.g_varchar2_table(80) := '2D707265766965773A686F766572202E647A2D696D61676520696D67207B0A2020202020202D7765626B69742D7472616E73666F726D3A207363616C6528312E30352C20312E3035293B0A2020202020202D6D6F7A2D7472616E73666F726D3A20736361';
wwv_flow_api.g_varchar2_table(81) := '6C6528312E30352C20312E3035293B0A2020202020202D6D732D7472616E73666F726D3A207363616C6528312E30352C20312E3035293B0A2020202020202D6F2D7472616E73666F726D3A207363616C6528312E30352C20312E3035293B0A2020202020';
wwv_flow_api.g_varchar2_table(82) := '207472616E73666F726D3A207363616C6528312E30352C20312E3035293B0A2020202020202D7765626B69742D66696C7465723A20626C757228387078293B0A20202020202066696C7465723A20626C757228387078293B207D0A202020202E64726F70';
wwv_flow_api.g_varchar2_table(83) := '7A6F6E65202E647A2D70726576696577202E647A2D696D616765207B0A202020202020626F726465722D7261646975733A20323070783B0A2020202020206F766572666C6F773A2068696464656E3B0A20202020202077696474683A2031323070783B0A';
wwv_flow_api.g_varchar2_table(84) := '2020202020206865696768743A2031323070783B0A202020202020706F736974696F6E3A2072656C61746976653B0A202020202020646973706C61793A20626C6F636B3B0A2020202020207A2D696E6465783A2031303B207D0A2020202020202E64726F';
wwv_flow_api.g_varchar2_table(85) := '707A6F6E65202E647A2D70726576696577202E647A2D696D61676520696D67207B0A2020202020202020646973706C61793A20626C6F636B3B207D0A202020202E64726F707A6F6E65202E647A2D707265766965772E647A2D73756363657373202E647A';
wwv_flow_api.g_varchar2_table(86) := '2D737563636573732D6D61726B207B0A2020202020202D7765626B69742D616E696D6174696F6E3A2070617373696E672D7468726F7567682033732063756269632D62657A69657228302E37372C20302C20302E3137352C2031293B0A2020202020202D';
wwv_flow_api.g_varchar2_table(87) := '6D6F7A2D616E696D6174696F6E3A2070617373696E672D7468726F7567682033732063756269632D62657A69657228302E37372C20302C20302E3137352C2031293B0A2020202020202D6D732D616E696D6174696F6E3A2070617373696E672D7468726F';
wwv_flow_api.g_varchar2_table(88) := '7567682033732063756269632D62657A69657228302E37372C20302C20302E3137352C2031293B0A2020202020202D6F2D616E696D6174696F6E3A2070617373696E672D7468726F7567682033732063756269632D62657A69657228302E37372C20302C';
wwv_flow_api.g_varchar2_table(89) := '20302E3137352C2031293B0A202020202020616E696D6174696F6E3A2070617373696E672D7468726F7567682033732063756269632D62657A69657228302E37372C20302C20302E3137352C2031293B207D0A202020202E64726F707A6F6E65202E647A';
wwv_flow_api.g_varchar2_table(90) := '2D707265766965772E647A2D6572726F72202E647A2D6572726F722D6D61726B207B0A2020202020206F7061636974793A20313B0A2020202020202D7765626B69742D616E696D6174696F6E3A20736C6964652D696E2033732063756269632D62657A69';
wwv_flow_api.g_varchar2_table(91) := '657228302E37372C20302C20302E3137352C2031293B0A2020202020202D6D6F7A2D616E696D6174696F6E3A20736C6964652D696E2033732063756269632D62657A69657228302E37372C20302C20302E3137352C2031293B0A2020202020202D6D732D';
wwv_flow_api.g_varchar2_table(92) := '616E696D6174696F6E3A20736C6964652D696E2033732063756269632D62657A69657228302E37372C20302C20302E3137352C2031293B0A2020202020202D6F2D616E696D6174696F6E3A20736C6964652D696E2033732063756269632D62657A696572';
wwv_flow_api.g_varchar2_table(93) := '28302E37372C20302C20302E3137352C2031293B0A202020202020616E696D6174696F6E3A20736C6964652D696E2033732063756269632D62657A69657228302E37372C20302C20302E3137352C2031293B207D0A202020202E64726F707A6F6E65202E';
wwv_flow_api.g_varchar2_table(94) := '647A2D70726576696577202E647A2D737563636573732D6D61726B2C202E64726F707A6F6E65202E647A2D70726576696577202E647A2D6572726F722D6D61726B207B0A202020202020706F696E7465722D6576656E74733A206E6F6E653B0A20202020';
wwv_flow_api.g_varchar2_table(95) := '20206F7061636974793A20303B0A2020202020207A2D696E6465783A203530303B0A202020202020706F736974696F6E3A206162736F6C7574653B0A202020202020646973706C61793A20626C6F636B3B0A202020202020746F703A203530253B0A2020';
wwv_flow_api.g_varchar2_table(96) := '202020206C6566743A203530253B0A2020202020206D617267696E2D6C6566743A202D323770783B0A2020202020206D617267696E2D746F703A202D323770783B207D0A2020202020202E64726F707A6F6E65202E647A2D70726576696577202E647A2D';
wwv_flow_api.g_varchar2_table(97) := '737563636573732D6D61726B207376672C202E64726F707A6F6E65202E647A2D70726576696577202E647A2D6572726F722D6D61726B20737667207B0A2020202020202020646973706C61793A20626C6F636B3B0A202020202020202077696474683A20';
wwv_flow_api.g_varchar2_table(98) := '353470783B0A20202020202020206865696768743A20353470783B207D0A202020202E64726F707A6F6E65202E647A2D707265766965772E647A2D70726F63657373696E67202E647A2D70726F6772657373207B0A2020202020206F7061636974793A20';
wwv_flow_api.g_varchar2_table(99) := '313B0A2020202020202D7765626B69742D7472616E736974696F6E3A20616C6C20302E3273206C696E6561723B0A2020202020202D6D6F7A2D7472616E736974696F6E3A20616C6C20302E3273206C696E6561723B0A2020202020202D6D732D7472616E';
wwv_flow_api.g_varchar2_table(100) := '736974696F6E3A20616C6C20302E3273206C696E6561723B0A2020202020202D6F2D7472616E736974696F6E3A20616C6C20302E3273206C696E6561723B0A2020202020207472616E736974696F6E3A20616C6C20302E3273206C696E6561723B207D0A';
wwv_flow_api.g_varchar2_table(101) := '202020202E64726F707A6F6E65202E647A2D707265766965772E647A2D636F6D706C657465202E647A2D70726F6772657373207B0A2020202020206F7061636974793A20303B0A2020202020202D7765626B69742D7472616E736974696F6E3A206F7061';
wwv_flow_api.g_varchar2_table(102) := '6369747920302E347320656173652D696E3B0A2020202020202D6D6F7A2D7472616E736974696F6E3A206F70616369747920302E347320656173652D696E3B0A2020202020202D6D732D7472616E736974696F6E3A206F70616369747920302E34732065';
wwv_flow_api.g_varchar2_table(103) := '6173652D696E3B0A2020202020202D6F2D7472616E736974696F6E3A206F70616369747920302E347320656173652D696E3B0A2020202020207472616E736974696F6E3A206F70616369747920302E347320656173652D696E3B207D0A202020202E6472';
wwv_flow_api.g_varchar2_table(104) := '6F707A6F6E65202E647A2D707265766965773A6E6F74282E647A2D70726F63657373696E6729202E647A2D70726F6772657373207B0A2020202020202D7765626B69742D616E696D6174696F6E3A2070756C7365203673206561736520696E66696E6974';
wwv_flow_api.g_varchar2_table(105) := '653B0A2020202020202D6D6F7A2D616E696D6174696F6E3A2070756C7365203673206561736520696E66696E6974653B0A2020202020202D6D732D616E696D6174696F6E3A2070756C7365203673206561736520696E66696E6974653B0A202020202020';
wwv_flow_api.g_varchar2_table(106) := '2D6F2D616E696D6174696F6E3A2070756C7365203673206561736520696E66696E6974653B0A202020202020616E696D6174696F6E3A2070756C7365203673206561736520696E66696E6974653B207D0A202020202E64726F707A6F6E65202E647A2D70';
wwv_flow_api.g_varchar2_table(107) := '726576696577202E647A2D70726F6772657373207B0A2020202020206F7061636974793A20313B0A2020202020207A2D696E6465783A20313030303B0A202020202020706F696E7465722D6576656E74733A206E6F6E653B0A202020202020706F736974';
wwv_flow_api.g_varchar2_table(108) := '696F6E3A206162736F6C7574653B0A2020202020206865696768743A20313670783B0A2020202020206C6566743A203530253B0A202020202020746F703A203530253B0A2020202020206D617267696E2D746F703A202D3870783B0A2020202020207769';
wwv_flow_api.g_varchar2_table(109) := '6474683A20383070783B0A2020202020206D617267696E2D6C6566743A202D343070783B0A2020202020206261636B67726F756E643A2072676261283235352C203235352C203235352C20302E39293B0A2020202020202D7765626B69742D7472616E73';
wwv_flow_api.g_varchar2_table(110) := '666F726D3A207363616C652831293B0A202020202020626F726465722D7261646975733A203870783B0A2020202020206F766572666C6F773A2068696464656E3B207D0A2020202020202E64726F707A6F6E65202E647A2D70726576696577202E647A2D';
wwv_flow_api.g_varchar2_table(111) := '70726F6772657373202E647A2D75706C6F6164207B0A20202020202020206261636B67726F756E643A20233333333B0A20202020202020206261636B67726F756E643A206C696E6561722D6772616469656E7428746F20626F74746F6D2C20233636362C';
wwv_flow_api.g_varchar2_table(112) := '2023343434293B0A2020202020202020706F736974696F6E3A206162736F6C7574653B0A2020202020202020746F703A20303B0A20202020202020206C6566743A20303B0A2020202020202020626F74746F6D3A20303B0A202020202020202077696474';
wwv_flow_api.g_varchar2_table(113) := '683A20303B0A20202020202020202D7765626B69742D7472616E736974696F6E3A207769647468203330306D7320656173652D696E2D6F75743B0A20202020202020202D6D6F7A2D7472616E736974696F6E3A207769647468203330306D732065617365';
wwv_flow_api.g_varchar2_table(114) := '2D696E2D6F75743B0A20202020202020202D6D732D7472616E736974696F6E3A207769647468203330306D7320656173652D696E2D6F75743B0A20202020202020202D6F2D7472616E736974696F6E3A207769647468203330306D7320656173652D696E';
wwv_flow_api.g_varchar2_table(115) := '2D6F75743B0A20202020202020207472616E736974696F6E3A207769647468203330306D7320656173652D696E2D6F75743B207D0A202020202E64726F707A6F6E65202E647A2D707265766965772E647A2D6572726F72202E647A2D6572726F722D6D65';
wwv_flow_api.g_varchar2_table(116) := '7373616765207B0A202020202020646973706C61793A20626C6F636B3B207D0A202020202E64726F707A6F6E65202E647A2D707265766965772E647A2D6572726F723A686F766572202E647A2D6572726F722D6D657373616765207B0A2020202020206F';
wwv_flow_api.g_varchar2_table(117) := '7061636974793A20313B0A202020202020706F696E7465722D6576656E74733A206175746F3B207D0A202020202E64726F707A6F6E65202E647A2D70726576696577202E647A2D6572726F722D6D657373616765207B0A202020202020706F696E746572';
wwv_flow_api.g_varchar2_table(118) := '2D6576656E74733A206E6F6E653B0A2020202020207A2D696E6465783A20313030303B0A202020202020706F736974696F6E3A206162736F6C7574653B0A202020202020646973706C61793A20626C6F636B3B0A202020202020646973706C61793A206E';
wwv_flow_api.g_varchar2_table(119) := '6F6E653B0A2020202020206F7061636974793A20303B0A2020202020202D7765626B69742D7472616E736974696F6E3A206F70616369747920302E337320656173653B0A2020202020202D6D6F7A2D7472616E736974696F6E3A206F7061636974792030';
wwv_flow_api.g_varchar2_table(120) := '2E337320656173653B0A2020202020202D6D732D7472616E736974696F6E3A206F70616369747920302E337320656173653B0A2020202020202D6F2D7472616E736974696F6E3A206F70616369747920302E337320656173653B0A202020202020747261';
wwv_flow_api.g_varchar2_table(121) := '6E736974696F6E3A206F70616369747920302E337320656173653B0A202020202020626F726465722D7261646975733A203870783B0A202020202020666F6E742D73697A653A20313370783B0A202020202020746F703A2031333070783B0A2020202020';
wwv_flow_api.g_varchar2_table(122) := '206C6566743A202D313070783B0A20202020202077696474683A2031343070783B0A2020202020206261636B67726F756E643A20236265323632363B0A2020202020206261636B67726F756E643A206C696E6561722D6772616469656E7428746F20626F';
wwv_flow_api.g_varchar2_table(123) := '74746F6D2C20236265323632362C2023613932323232293B0A20202020202070616464696E673A20302E35656D20312E32656D3B0A202020202020636F6C6F723A2077686974653B207D0A2020202020202E64726F707A6F6E65202E647A2D7072657669';
wwv_flow_api.g_varchar2_table(124) := '6577202E647A2D6572726F722D6D6573736167653A6166746572207B0A2020202020202020636F6E74656E743A2027273B0A2020202020202020706F736974696F6E3A206162736F6C7574653B0A2020202020202020746F703A202D3670783B0A202020';
wwv_flow_api.g_varchar2_table(125) := '20202020206C6566743A20363470783B0A202020202020202077696474683A20303B0A20202020202020206865696768743A20303B0A2020202020202020626F726465722D6C6566743A2036707820736F6C6964207472616E73706172656E743B0A2020';
wwv_flow_api.g_varchar2_table(126) := '202020202020626F726465722D72696768743A2036707820736F6C6964207472616E73706172656E743B0A2020202020202020626F726465722D626F74746F6D3A2036707820736F6C696420236265323632363B207D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72338869719797127)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'css/dropzone.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '402D7765626B69742D6B65796672616D65732070617373696E672D7468726F7567687B30257B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592834307078293B2D6D6F7A2D7472616E73666F726D3A7472';
wwv_flow_api.g_varchar2_table(2) := '616E736C617465592834307078293B2D6D732D7472616E73666F726D3A7472616E736C617465592834307078293B2D6F2D7472616E73666F726D3A7472616E736C617465592834307078293B7472616E73666F726D3A7472616E736C6174655928343070';
wwv_flow_api.g_varchar2_table(3) := '78297D3330252C3730257B6F7061636974793A313B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592830293B2D6D732D7472616E73666F726D3A7472616E';
wwv_flow_api.g_varchar2_table(4) := '736C617465592830293B2D6F2D7472616E73666F726D3A7472616E736C617465592830293B7472616E73666F726D3A7472616E736C617465592830297D746F7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C6174';
wwv_flow_api.g_varchar2_table(5) := '6559282D34307078293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746559282D34307078293B2D6D732D7472616E73666F726D3A7472616E736C61746559282D34307078293B2D6F2D7472616E73666F726D3A7472616E736C61746559282D';
wwv_flow_api.g_varchar2_table(6) := '34307078293B7472616E73666F726D3A7472616E736C61746559282D34307078297D7D402D6D6F7A2D6B65796672616D65732070617373696E672D7468726F7567687B30257B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472';
wwv_flow_api.g_varchar2_table(7) := '616E736C617465592834307078293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592834307078293B2D6D732D7472616E73666F726D3A7472616E736C617465592834307078293B2D6F2D7472616E73666F726D3A7472616E736C617465';
wwv_flow_api.g_varchar2_table(8) := '592834307078293B7472616E73666F726D3A7472616E736C617465592834307078297D3330252C3730257B6F7061636974793A313B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B2D6D6F7A2D7472616E73666F726D3A';
wwv_flow_api.g_varchar2_table(9) := '7472616E736C617465592830293B2D6D732D7472616E73666F726D3A7472616E736C617465592830293B2D6F2D7472616E73666F726D3A7472616E736C617465592830293B7472616E73666F726D3A7472616E736C617465592830297D746F7B6F706163';
wwv_flow_api.g_varchar2_table(10) := '6974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D34307078293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746559282D34307078293B2D6D732D7472616E73666F726D3A7472616E736C6174655928';
wwv_flow_api.g_varchar2_table(11) := '2D34307078293B2D6F2D7472616E73666F726D3A7472616E736C61746559282D34307078293B7472616E73666F726D3A7472616E736C61746559282D34307078297D7D406B65796672616D65732070617373696E672D7468726F7567687B30257B6F7061';
wwv_flow_api.g_varchar2_table(12) := '636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592834307078293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592834307078293B2D6D732D7472616E73666F726D3A7472616E736C617465592834';
wwv_flow_api.g_varchar2_table(13) := '307078293B2D6F2D7472616E73666F726D3A7472616E736C617465592834307078293B7472616E73666F726D3A7472616E736C617465592834307078297D3330252C3730257B6F7061636974793A313B2D7765626B69742D7472616E73666F726D3A7472';
wwv_flow_api.g_varchar2_table(14) := '616E736C617465592830293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592830293B2D6D732D7472616E73666F726D3A7472616E736C617465592830293B2D6F2D7472616E73666F726D3A7472616E736C617465592830293B7472616E';
wwv_flow_api.g_varchar2_table(15) := '73666F726D3A7472616E736C617465592830297D746F7B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D34307078293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746559282D34307078';
wwv_flow_api.g_varchar2_table(16) := '293B2D6D732D7472616E73666F726D3A7472616E736C61746559282D34307078293B2D6F2D7472616E73666F726D3A7472616E736C61746559282D34307078293B7472616E73666F726D3A7472616E736C61746559282D34307078297D7D402D7765626B';
wwv_flow_api.g_varchar2_table(17) := '69742D6B65796672616D657320736C6964652D696E7B30257B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592834307078293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592834307078';
wwv_flow_api.g_varchar2_table(18) := '293B2D6D732D7472616E73666F726D3A7472616E736C617465592834307078293B2D6F2D7472616E73666F726D3A7472616E736C617465592834307078293B7472616E73666F726D3A7472616E736C617465592834307078297D3330257B6F7061636974';
wwv_flow_api.g_varchar2_table(19) := '793A313B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592830293B2D6D732D7472616E73666F726D3A7472616E736C617465592830293B2D6F2D7472616E';
wwv_flow_api.g_varchar2_table(20) := '73666F726D3A7472616E736C617465592830293B7472616E73666F726D3A7472616E736C617465592830297D7D402D6D6F7A2D6B65796672616D657320736C6964652D696E7B30257B6F7061636974793A303B2D7765626B69742D7472616E73666F726D';
wwv_flow_api.g_varchar2_table(21) := '3A7472616E736C617465592834307078293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592834307078293B2D6D732D7472616E73666F726D3A7472616E736C617465592834307078293B2D6F2D7472616E73666F726D3A7472616E736C';
wwv_flow_api.g_varchar2_table(22) := '617465592834307078293B7472616E73666F726D3A7472616E736C617465592834307078297D3330257B6F7061636974793A313B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B2D6D6F7A2D7472616E73666F726D3A74';
wwv_flow_api.g_varchar2_table(23) := '72616E736C617465592830293B2D6D732D7472616E73666F726D3A7472616E736C617465592830293B2D6F2D7472616E73666F726D3A7472616E736C617465592830293B7472616E73666F726D3A7472616E736C617465592830297D7D406B6579667261';
wwv_flow_api.g_varchar2_table(24) := '6D657320736C6964652D696E7B30257B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592834307078293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592834307078293B2D6D732D747261';
wwv_flow_api.g_varchar2_table(25) := '6E73666F726D3A7472616E736C617465592834307078293B2D6F2D7472616E73666F726D3A7472616E736C617465592834307078293B7472616E73666F726D3A7472616E736C617465592834307078297D3330257B6F7061636974793A313B2D7765626B';
wwv_flow_api.g_varchar2_table(26) := '69742D7472616E73666F726D3A7472616E736C617465592830293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592830293B2D6D732D7472616E73666F726D3A7472616E736C617465592830293B2D6F2D7472616E73666F726D3A747261';
wwv_flow_api.g_varchar2_table(27) := '6E736C617465592830293B7472616E73666F726D3A7472616E736C617465592830297D7D402D7765626B69742D6B65796672616D65732070756C73657B30252C3230257B2D7765626B69742D7472616E73666F726D3A7363616C652831293B2D6D6F7A2D';
wwv_flow_api.g_varchar2_table(28) := '7472616E73666F726D3A7363616C652831293B2D6D732D7472616E73666F726D3A7363616C652831293B2D6F2D7472616E73666F726D3A7363616C652831293B7472616E73666F726D3A7363616C652831297D3130257B2D7765626B69742D7472616E73';
wwv_flow_api.g_varchar2_table(29) := '666F726D3A7363616C6528312E31293B2D6D6F7A2D7472616E73666F726D3A7363616C6528312E31293B2D6D732D7472616E73666F726D3A7363616C6528312E31293B2D6F2D7472616E73666F726D3A7363616C6528312E31293B7472616E73666F726D';
wwv_flow_api.g_varchar2_table(30) := '3A7363616C6528312E31297D7D402D6D6F7A2D6B65796672616D65732070756C73657B30252C3230257B2D7765626B69742D7472616E73666F726D3A7363616C652831293B2D6D6F7A2D7472616E73666F726D3A7363616C652831293B2D6D732D747261';
wwv_flow_api.g_varchar2_table(31) := '6E73666F726D3A7363616C652831293B2D6F2D7472616E73666F726D3A7363616C652831293B7472616E73666F726D3A7363616C652831297D3130257B2D7765626B69742D7472616E73666F726D3A7363616C6528312E31293B2D6D6F7A2D7472616E73';
wwv_flow_api.g_varchar2_table(32) := '666F726D3A7363616C6528312E31293B2D6D732D7472616E73666F726D3A7363616C6528312E31293B2D6F2D7472616E73666F726D3A7363616C6528312E31293B7472616E73666F726D3A7363616C6528312E31297D7D406B65796672616D6573207075';
wwv_flow_api.g_varchar2_table(33) := '6C73657B30252C3230257B2D7765626B69742D7472616E73666F726D3A7363616C652831293B2D6D6F7A2D7472616E73666F726D3A7363616C652831293B2D6D732D7472616E73666F726D3A7363616C652831293B2D6F2D7472616E73666F726D3A7363';
wwv_flow_api.g_varchar2_table(34) := '616C652831293B7472616E73666F726D3A7363616C652831297D3130257B2D7765626B69742D7472616E73666F726D3A7363616C6528312E31293B2D6D6F7A2D7472616E73666F726D3A7363616C6528312E31293B2D6D732D7472616E73666F726D3A73';
wwv_flow_api.g_varchar2_table(35) := '63616C6528312E31293B2D6F2D7472616E73666F726D3A7363616C6528312E31293B7472616E73666F726D3A7363616C6528312E31297D7D2E64726F707A6F6E652C2E64726F707A6F6E65202A7B626F782D73697A696E673A626F726465722D626F787D';
wwv_flow_api.g_varchar2_table(36) := '2E64726F707A6F6E657B6D696E2D6865696768743A31353070783B626F726465723A32707820736F6C6964207267626128302C302C302C2E33293B6261636B67726F756E643A236666663B70616464696E673A323070787D2E64726F707A6F6E652E647A';
wwv_flow_api.g_varchar2_table(37) := '2D636C69636B61626C652C2E64726F707A6F6E652E647A2D636C69636B61626C65202E647A2D6D6573736167652C2E64726F707A6F6E652E647A2D636C69636B61626C65202E647A2D6D657373616765202A7B637572736F723A706F696E7465727D2E64';
wwv_flow_api.g_varchar2_table(38) := '726F707A6F6E652E647A2D636C69636B61626C65202A7B637572736F723A64656661756C747D2E64726F707A6F6E652E647A2D73746172746564202E647A2D6D6573736167657B646973706C61793A6E6F6E657D2E64726F707A6F6E652E647A2D647261';
wwv_flow_api.g_varchar2_table(39) := '672D686F7665727B626F726465722D7374796C653A736F6C69647D2E64726F707A6F6E652E647A2D647261672D686F766572202E647A2D6D6573736167657B6F7061636974793A2E357D2E64726F707A6F6E65202E647A2D6D6573736167657B74657874';
wwv_flow_api.g_varchar2_table(40) := '2D616C69676E3A63656E7465723B6D617267696E3A32656D20307D2E64726F707A6F6E65202E647A2D707265766965777B706F736974696F6E3A72656C61746976653B646973706C61793A696E6C696E652D626C6F636B3B766572746963616C2D616C69';
wwv_flow_api.g_varchar2_table(41) := '676E3A746F703B6D617267696E3A313670783B6D696E2D6865696768743A31303070787D2E64726F707A6F6E65202E647A2D707265766965773A686F7665727B7A2D696E6465783A313030307D2E64726F707A6F6E65202E647A2D707265766965772E64';
wwv_flow_api.g_varchar2_table(42) := '7A2D66696C652D70726576696577202E647A2D696D6167657B626F726465722D7261646975733A323070783B6261636B67726F756E643A233939393B6261636B67726F756E643A6C696E6561722D6772616469656E7428746F20626F74746F6D2C236565';
wwv_flow_api.g_varchar2_table(43) := '652C23646464297D2E64726F707A6F6E65202E647A2D707265766965772E647A2D66696C652D70726576696577202E647A2D64657461696C737B6F7061636974793A317D2E64726F707A6F6E65202E647A2D707265766965772E647A2D696D6167652D70';
wwv_flow_api.g_varchar2_table(44) := '7265766965777B6261636B67726F756E643A236666667D2E64726F707A6F6E65202E647A2D707265766965772E647A2D696D6167652D70726576696577202E647A2D64657461696C737B2D7765626B69742D7472616E736974696F6E3A6F706163697479';
wwv_flow_api.g_varchar2_table(45) := '202E3273206C696E6561723B2D6D6F7A2D7472616E736974696F6E3A6F706163697479202E3273206C696E6561723B2D6D732D7472616E736974696F6E3A6F706163697479202E3273206C696E6561723B2D6F2D7472616E736974696F6E3A6F70616369';
wwv_flow_api.g_varchar2_table(46) := '7479202E3273206C696E6561723B7472616E736974696F6E3A6F706163697479202E3273206C696E6561727D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D72656D6F76657B666F6E742D73697A653A313470783B746578742D616C69';
wwv_flow_api.g_varchar2_table(47) := '676E3A63656E7465723B646973706C61793A626C6F636B3B637572736F723A706F696E7465723B626F726465723A6E6F6E657D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D72656D6F76653A686F7665727B746578742D6465636F72';
wwv_flow_api.g_varchar2_table(48) := '6174696F6E3A756E6465726C696E657D2E64726F707A6F6E65202E647A2D707265766965773A686F766572202E647A2D64657461696C737B6F7061636974793A317D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C737B';
wwv_flow_api.g_varchar2_table(49) := '7A2D696E6465783A32303B706F736974696F6E3A6162736F6C7574653B746F703A303B6C6566743A303B6F7061636974793A303B666F6E742D73697A653A313370783B6D696E2D77696474683A313030253B6D61782D77696474683A313030253B706164';
wwv_flow_api.g_varchar2_table(50) := '64696E673A32656D2031656D3B746578742D616C69676E3A63656E7465723B636F6C6F723A7267626128302C302C302C2E39293B6C696E652D6865696768743A313530257D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D6465746169';
wwv_flow_api.g_varchar2_table(51) := '6C73202E647A2D73697A657B6D617267696E2D626F74746F6D3A31656D3B666F6E742D73697A653A313670787D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73202E647A2D66696C656E616D657B77686974652D7370';
wwv_flow_api.g_varchar2_table(52) := '6163653A6E6F777261707D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73202E647A2D66696C656E616D653A686F766572207370616E7B626F726465723A31707820736F6C69642072676261283230302C3230302C32';
wwv_flow_api.g_varchar2_table(53) := '30302C2E38293B6261636B67726F756E642D636F6C6F723A72676261283235352C3235352C3235352C2E38297D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73202E647A2D66696C656E616D653A6E6F74283A686F76';
wwv_flow_api.g_varchar2_table(54) := '6572297B6F766572666C6F773A68696464656E3B746578742D6F766572666C6F773A656C6C69707369737D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73202E647A2D66696C656E616D653A6E6F74283A686F766572';
wwv_flow_api.g_varchar2_table(55) := '29207370616E7B626F726465723A31707820736F6C6964207472616E73706172656E747D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D64657461696C73202E647A2D66696C656E616D65207370616E2C2E64726F707A6F6E65202E64';
wwv_flow_api.g_varchar2_table(56) := '7A2D70726576696577202E647A2D64657461696C73202E647A2D73697A65207370616E7B6261636B67726F756E642D636F6C6F723A72676261283235352C3235352C3235352C2E34293B70616464696E673A30202E34656D3B626F726465722D72616469';
wwv_flow_api.g_varchar2_table(57) := '75733A3370787D2E64726F707A6F6E65202E647A2D707265766965773A686F766572202E647A2D696D61676520696D677B2D7765626B69742D7472616E73666F726D3A7363616C6528312E30352C312E3035293B2D6D6F7A2D7472616E73666F726D3A73';
wwv_flow_api.g_varchar2_table(58) := '63616C6528312E30352C312E3035293B2D6D732D7472616E73666F726D3A7363616C6528312E30352C312E3035293B2D6F2D7472616E73666F726D3A7363616C6528312E30352C312E3035293B7472616E73666F726D3A7363616C6528312E30352C312E';
wwv_flow_api.g_varchar2_table(59) := '3035293B2D7765626B69742D66696C7465723A626C757228387078293B66696C7465723A626C757228387078297D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D696D6167657B626F726465722D7261646975733A323070783B6F7665';
wwv_flow_api.g_varchar2_table(60) := '72666C6F773A68696464656E3B77696474683A31323070783B6865696768743A31323070783B706F736974696F6E3A72656C61746976653B646973706C61793A626C6F636B3B7A2D696E6465783A31307D2E64726F707A6F6E65202E647A2D7072657669';
wwv_flow_api.g_varchar2_table(61) := '6577202E647A2D696D61676520696D677B646973706C61793A626C6F636B7D2E64726F707A6F6E65202E647A2D707265766965772E647A2D73756363657373202E647A2D737563636573732D6D61726B7B2D7765626B69742D616E696D6174696F6E3A70';
wwv_flow_api.g_varchar2_table(62) := '617373696E672D7468726F7567682033732063756269632D62657A696572282E37372C302C2E3137352C31293B2D6D6F7A2D616E696D6174696F6E3A70617373696E672D7468726F7567682033732063756269632D62657A696572282E37372C302C2E31';
wwv_flow_api.g_varchar2_table(63) := '37352C31293B2D6D732D616E696D6174696F6E3A70617373696E672D7468726F7567682033732063756269632D62657A696572282E37372C302C2E3137352C31293B2D6F2D616E696D6174696F6E3A70617373696E672D7468726F756768203373206375';
wwv_flow_api.g_varchar2_table(64) := '6269632D62657A696572282E37372C302C2E3137352C31293B616E696D6174696F6E3A70617373696E672D7468726F7567682033732063756269632D62657A696572282E37372C302C2E3137352C31297D2E64726F707A6F6E65202E647A2D7072657669';
wwv_flow_api.g_varchar2_table(65) := '65772E647A2D6572726F72202E647A2D6572726F722D6D61726B7B6F7061636974793A313B2D7765626B69742D616E696D6174696F6E3A736C6964652D696E2033732063756269632D62657A696572282E37372C302C2E3137352C31293B2D6D6F7A2D61';
wwv_flow_api.g_varchar2_table(66) := '6E696D6174696F6E3A736C6964652D696E2033732063756269632D62657A696572282E37372C302C2E3137352C31293B2D6D732D616E696D6174696F6E3A736C6964652D696E2033732063756269632D62657A696572282E37372C302C2E3137352C3129';
wwv_flow_api.g_varchar2_table(67) := '3B2D6F2D616E696D6174696F6E3A736C6964652D696E2033732063756269632D62657A696572282E37372C302C2E3137352C31293B616E696D6174696F6E3A736C6964652D696E2033732063756269632D62657A696572282E37372C302C2E3137352C31';
wwv_flow_api.g_varchar2_table(68) := '297D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D6572726F722D6D61726B2C2E64726F707A6F6E65202E647A2D70726576696577202E647A2D737563636573732D6D61726B7B706F696E7465722D6576656E74733A6E6F6E653B6F70';
wwv_flow_api.g_varchar2_table(69) := '61636974793A303B7A2D696E6465783A3530303B706F736974696F6E3A6162736F6C7574653B646973706C61793A626C6F636B3B746F703A3530253B6C6566743A3530253B6D617267696E2D6C6566743A2D323770783B6D617267696E2D746F703A2D32';
wwv_flow_api.g_varchar2_table(70) := '3770787D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D6572726F722D6D61726B207376672C2E64726F707A6F6E65202E647A2D70726576696577202E647A2D737563636573732D6D61726B207376677B646973706C61793A626C6F63';
wwv_flow_api.g_varchar2_table(71) := '6B3B77696474683A353470783B6865696768743A353470787D2E64726F707A6F6E65202E647A2D707265766965772E647A2D70726F63657373696E67202E647A2D70726F67726573737B6F7061636974793A313B2D7765626B69742D7472616E73697469';
wwv_flow_api.g_varchar2_table(72) := '6F6E3A616C6C202E3273206C696E6561723B2D6D6F7A2D7472616E736974696F6E3A616C6C202E3273206C696E6561723B2D6D732D7472616E736974696F6E3A616C6C202E3273206C696E6561723B2D6F2D7472616E736974696F6E3A616C6C202E3273';
wwv_flow_api.g_varchar2_table(73) := '206C696E6561723B7472616E736974696F6E3A616C6C202E3273206C696E6561727D2E64726F707A6F6E65202E647A2D707265766965772E647A2D636F6D706C657465202E647A2D70726F67726573737B6F7061636974793A303B2D7765626B69742D74';
wwv_flow_api.g_varchar2_table(74) := '72616E736974696F6E3A6F706163697479202E347320656173652D696E3B2D6D6F7A2D7472616E736974696F6E3A6F706163697479202E347320656173652D696E3B2D6D732D7472616E736974696F6E3A6F706163697479202E347320656173652D696E';
wwv_flow_api.g_varchar2_table(75) := '3B2D6F2D7472616E736974696F6E3A6F706163697479202E347320656173652D696E3B7472616E736974696F6E3A6F706163697479202E347320656173652D696E7D2E64726F707A6F6E65202E647A2D707265766965773A6E6F74282E647A2D70726F63';
wwv_flow_api.g_varchar2_table(76) := '657373696E6729202E647A2D70726F67726573737B2D7765626B69742D616E696D6174696F6E3A70756C7365203673206561736520696E66696E6974653B2D6D6F7A2D616E696D6174696F6E3A70756C7365203673206561736520696E66696E6974653B';
wwv_flow_api.g_varchar2_table(77) := '2D6D732D616E696D6174696F6E3A70756C7365203673206561736520696E66696E6974653B2D6F2D616E696D6174696F6E3A70756C7365203673206561736520696E66696E6974653B616E696D6174696F6E3A70756C7365203673206561736520696E66';
wwv_flow_api.g_varchar2_table(78) := '696E6974657D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D70726F67726573737B6F7061636974793A313B7A2D696E6465783A313030303B706F696E7465722D6576656E74733A6E6F6E653B706F736974696F6E3A6162736F6C7574';
wwv_flow_api.g_varchar2_table(79) := '653B6865696768743A313670783B6C6566743A3530253B746F703A3530253B6D617267696E2D746F703A2D3870783B77696474683A383070783B6D617267696E2D6C6566743A2D343070783B6261636B67726F756E643A72676261283235352C3235352C';
wwv_flow_api.g_varchar2_table(80) := '3235352C2E39293B2D7765626B69742D7472616E73666F726D3A7363616C652831293B626F726465722D7261646975733A3870783B6F766572666C6F773A68696464656E7D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D70726F6772';
wwv_flow_api.g_varchar2_table(81) := '657373202E647A2D75706C6F61647B6261636B67726F756E643A233333333B6261636B67726F756E643A6C696E6561722D6772616469656E7428746F20626F74746F6D2C233636362C23343434293B706F736974696F6E3A6162736F6C7574653B746F70';
wwv_flow_api.g_varchar2_table(82) := '3A303B6C6566743A303B626F74746F6D3A303B77696474683A303B2D7765626B69742D7472616E736974696F6E3A7769647468203330306D7320656173652D696E2D6F75743B2D6D6F7A2D7472616E736974696F6E3A7769647468203330306D73206561';
wwv_flow_api.g_varchar2_table(83) := '73652D696E2D6F75743B2D6D732D7472616E736974696F6E3A7769647468203330306D7320656173652D696E2D6F75743B2D6F2D7472616E736974696F6E3A7769647468203330306D7320656173652D696E2D6F75743B7472616E736974696F6E3A7769';
wwv_flow_api.g_varchar2_table(84) := '647468203330306D7320656173652D696E2D6F75747D2E64726F707A6F6E65202E647A2D707265766965772E647A2D6572726F72202E647A2D6572726F722D6D6573736167657B646973706C61793A626C6F636B7D2E64726F707A6F6E65202E647A2D70';
wwv_flow_api.g_varchar2_table(85) := '7265766965772E647A2D6572726F723A686F766572202E647A2D6572726F722D6D6573736167657B6F7061636974793A313B706F696E7465722D6576656E74733A6175746F7D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D6572726F';
wwv_flow_api.g_varchar2_table(86) := '722D6D6573736167657B706F696E7465722D6576656E74733A6E6F6E653B7A2D696E6465783A313030303B706F736974696F6E3A6162736F6C7574653B646973706C61793A6E6F6E653B6F7061636974793A303B2D7765626B69742D7472616E73697469';
wwv_flow_api.g_varchar2_table(87) := '6F6E3A6F706163697479202E337320656173653B2D6D6F7A2D7472616E736974696F6E3A6F706163697479202E337320656173653B2D6D732D7472616E736974696F6E3A6F706163697479202E337320656173653B2D6F2D7472616E736974696F6E3A6F';
wwv_flow_api.g_varchar2_table(88) := '706163697479202E337320656173653B7472616E736974696F6E3A6F706163697479202E337320656173653B626F726465722D7261646975733A3870783B666F6E742D73697A653A313370783B746F703A31333070783B6C6566743A2D313070783B7769';
wwv_flow_api.g_varchar2_table(89) := '6474683A31343070783B6261636B67726F756E643A236265323632363B6261636B67726F756E643A6C696E6561722D6772616469656E7428746F20626F74746F6D2C236265323632362C23613932323232293B70616464696E673A2E35656D20312E3265';
wwv_flow_api.g_varchar2_table(90) := '6D3B636F6C6F723A236666667D2E64726F707A6F6E65202E647A2D70726576696577202E647A2D6572726F722D6D6573736167653A61667465727B636F6E74656E743A27273B706F736974696F6E3A6162736F6C7574653B746F703A2D3670783B6C6566';
wwv_flow_api.g_varchar2_table(91) := '743A363470783B77696474683A303B6865696768743A303B626F726465722D6C6566743A36707820736F6C6964207472616E73706172656E743B626F726465722D72696768743A36707820736F6C6964207472616E73706172656E743B626F726465722D';
wwv_flow_api.g_varchar2_table(92) := '626F74746F6D3A36707820736F6C696420236265323632367D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72339293396797130)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'css/dropzone.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000017BC494441547801ED9D5B901CD759C74F77CF6D6FD24AB22CCB96AFB19064C92476B093D8C1C4384528538400962131553CC10355F0C60355141105';
wwv_flow_api.g_varchar2_table(7) := 'B64C5195D75049A84A417C292B50C5CD246553244A0281F8266C0512701CCB966D599275D9D5EEECCE7437BFFFE9E99D9ED9DBECCC99D999D59CD26C779F3EFD9DEF7CFFEF76CE996919E3A0C4B1F11C90595712F1A143FE461847B3103B064642F13C13';
wwv_flow_api.g_varchar2_table(8) := '8B70FC6F9FB9D384DE27399B34711C19DF6FEEAF7FAEC59F894BC69F386346AEFBA277FB1FBE1EC70703638E44E978FA87D9F639E908E006708F3EF40002FB92D954D86CD959A0AC138B7FFB5C3A7D728131A856616D9B31D18EAF994AEE77BC0FFDFE6B';
wwv_flow_api.g_varchar2_table(9) := 'F1BF1ECA998F1D0A370AC8D9D1AE598CD278CF3B12C6477F63A7F1A267CC6469BF395FAE80A76F9DB6704DF16DA5A7E6F6CDD7CD1CA6F7559F3DCFB64BEBD3E3425B41381F99DCF6593371E384A984DF355EFC69EFB63FF8F14602B9331F7A2495647C13';
wwv_flow_api.g_varchar2_table(10) := '12DE632ECE49D0025774171F55B7D267B9E7D2FAE667B3F5D9F36CBBB43E3DEA9E3D8F51392F6735A3529D369B473E0CEF8FC5C7FEFC46EFDE4355F38D43C14688C99D017C70BFEC029145580316212B4DFF26B69BD4F4E5798D5FE3117739BF3063CC44';
wwv_flow_api.g_varchar2_table(11) := 'E92E13563714C89D017CE478E278235F79B4D22D8BF7C0FCB1EA69FF200778BF580E01F923A65A7D3C7EFEF0CDD692CD5364D7B2F6C12C9D019C5AB0C69E403C185248FC4EE2572CC738631F0C3D809C02E44DB86BCF3C1EBFF827BB3DEFC1D07CE38F71';
wwv_flow_api.g_varchar2_table(12) := 'D7830972670037C339287ADECCA7C20B1ACA3FC9C333176765C9779838F758DD928F0CA425BB05B819F041B9F6B060B968CF936D2B090364EBAEEFE02C71D7B2642390D570708A3B80076AD84D00A5165CAFAE833C8E257BE6C9F8B947F65A773D6031D9';
wwv_flow_api.g_varchar2_table(13) := '1DC0695CAB0B6970CEEC4ADC220D4D409EB696FC4156E59EA8833C38EEDA1DC08BE43338F8DA04716976259FC45D8F173F308820BB0358021A342B4EF9B53138BD588474DD92057280253FFF67FBACBB3ED2FF96EC0EE065E5B34860FD53B1E075164E96';
wwv_flow_api.g_varchar2_table(14) := 'E32DB164B9EB314036E153F1B1870F780F9278F539C8EE005E4E34FD5CDFA0942D829CCC930F98084B1E0090DD012CF9AC2AA33E43BB81DF06B49763B49E5D8F950E982A207F2FB5E407FB729EEC0EE096E4B39CDC7A5CDF19AFBE9D29CB92270059D9F5';
wwv_flow_api.g_varchar2_table(15) := '0B8FBEDF7BF008EE1A90F9E2408F47B36277EE9869B08615FB5CFF9BCDBCAE75F122DD319B2E57CD26403631967CF8360BF22DC7BD7E02D91DC0B28ACE2C63FD805F7A1EBC1A3F529380B5EB2A96BC0FAB7E3C7EA9FF40760770B355AC269E7EB8DFA090';
wwv_flow_api.g_varchar2_table(16) := '0D17AD7297807CD15AF25E136640FE2CFADE07EEDA1DC06DC9A7553976BB5D47CC6BE53AB5E4BD78B127E2170FDFE1798722D30720BB0358180C8A15A77836F0DB70B1568D4A2C59EE7ABCB40790D96AEC0F90DD02BC56B1AC57FB662C176F36B4C35962';
wwv_flow_api.g_varchar2_table(17) := 'C972D7E3A59BF986CB63FD00F2E50970337C76A9B2B9B2ADEBBABB1E2FEEC6921F8BBFF7A777AEA7BB760770B355B4259F757AC85AB0B3BE139035851A2FED36B98079F2231F592F90DD019CC6356772EA21213B4D72DA5F129305F258E9269293C7D70B';
wwv_flow_api.g_varchar2_table(18) := '6477003B954F8F89AD75A1A335F6EA208F976E582F90DD01ACE10C9A15A7FCBA8BC1CDD02F06F9B9473F6ADDB5C4D58379B23B805361350FB19FAF257E5B164ED20A97C74690FD1877FDE83DDE21E6C99438EEEEDAB53B805D8AA457B41A94B247208F95';
wwv_flow_api.g_varchar2_table(19) := 'AE05D6AFD441FE2CDFC8ED1EC8FC74C351917CBA2A23477C66C934F0DB8076B695AB73F516189B5D17AF35D3735F898F3DF2103FCDFC160863C97C335BAB5F8E8B3B0BEEBA7C1C8E7C495E1BD076D85903A9DA146A8E2914208764D72F3D7C2F20C3D1A1';
wwv_flow_api.g_varchar2_table(20) := 'AE58B23B801BC6D1E7178BB014E24BA2DE8D8124205F9AAB304FDEC53743B0E4C33FCB57EF61C0BDBB760B70CF64E458EE76A16311EA8E3B69204767FCB2719A9FDA8E97AEE667CAC4E487EFEB8625BB0358F2E9A98C1A04D6DE45AA909A26F1AFA170A9';
wwv_flow_api.g_varchar2_table(21) := '2A5B9DDECA5E67CED347D3A36C71A9671190A594B4B3BF75AA815CDCC90F2AFEAAF2C2E18FCB92158B5D255EEE0016EB96FD06310DC805629572667F60261BAB7D1614377B9D39573B95F4A8F64B3D4B07B6E5423B9AF1583E49BC4A57E73C2CF9F9C33F';
wwv_flow_api.g_varchar2_table(22) := '9FD0026407F36477005BAEF467004A8322EAA7AF7EC4871C37E0BD2201F96CAF3FB9C0CCCCCF9BB1D11D7CEFFACBF1B1CF25203357C6DA6BEAD39E5CDD4D93DAEB7F7D9E42649A9A78801A47B34179FA5419E39D76BF24BDB6E1C553663A1F043BE62B95';
wwv_flow_api.g_varchar2_table(23) := 'CF9D7FFAB7FF77F2FE2FBC6A8E1C44F3F8425F9BE5F20418612566C1B760E3D9A25FB9144CCD847118C69ECFEF841B0CBC2658B55FAA3E95FB4AF7B3F7B2E7E9B33A26F5711ECD0B3D3FD8E7F9B95D54BF6AEC6FB017DE95917DA4A57377008BC3412AF0';
wwv_flow_api.g_varchar2_table(24) := 'AB6487CCD52B1682BCAC798A9F05472C3504BAB7C458561BE24AF7B3F7B2E70DDDD069A1E09BF94A588D2ACC951D1477004B224B49C50193DD22A164C782CCA190F7CC84BE5A35139A9071E807FF3D198E3AA921CE2142C1927786E413688EA4AFC96853';
wwv_flow_api.g_varchar2_table(25) := '089767929511562DA3955FF600D91B1F093CC0F510B4AD537D573F82B7D60758D7A0AE337830FB9A8C7A75CB67EE00166B3D51F996C7B6F686F05F94258F04F6257DB2EE9E962EF4E70EE02E30D753E1663A5B5790337CB8387507B00B6EFA88C64601D9';
wwv_flow_api.g_varchar2_table(26) := '1DC072D18B22481F21D6062BC5428FDD7517E4E70EE00DE4A217748131F5D492BB204377002F4865E39DF4DC921D8AD02DC05DD04087636D9F942C1977BD693460A938993BB74FACB74FBA037803C6E0062800B9C076CF440DE4684094D91DC01AF0800C';
wwv_flow_api.g_varchar2_table(27) := 'BA01B8355ED8152F40CE21B94100D91DC0125417B2C035CABFFBCD33963C0820BB05B8FBE2ED9B1E64C98AC9FD0EF210E07655064BCE1393FB1DE421C0ED025C7BAEDF411E02DC21C07A7C016436FA7ABE41B10AFF4380571150ABB7F38AC9EC420580DC';
wwv_flow_api.g_varchar2_table(28) := '4FD9F510E056115CAD9D62720D64BE42D73796EC0EE0CB618AD40AC84ABCFAC892DD01AC450E7D86A5AF2CD91DC0027668C5897A67DCF57AC764B7000FADB72E810CC88AC9EB95780D01AE43E2FE2C0372BE1590BBE001DD023C8CC18B95642D2077417E';
wwv_flow_api.g_varchar2_table(29) := '6E01EE82062E96D800D6005CAE36856AC9921D0ED12DC00E19DB70A46A20EB2BB9BD04D92DC05D70311B0A68E4631743D885EA15C86E01DE5068746930B2E4DA2E542F40760BF03006B7A615FCC0AD5720BB05B8B5E10D5BC910322017F839A39D2753EF';
wwv_flow_api.g_varchar2_table(30) := 'DA468600AF97BA65409E18F5ED17FA62E76FC9D27FA5EAAAB8563D577CF5331D642650E5AE27467CBBAFDCF13B1B9AC6EB0EE06106DD24DAD62EEDCF57D3C46B8CEC1AB05D2E6BBA037868C1AD21BA5C2B2C591B13FADEB540AE56966BB8B67A77BFF05F';
wwv_flow_api.g_varchar2_table(31) := '5BBFC3D6CD129081C80B6A0A85BB2E15DB7EEF4A036577000F5D748360DBBE408E0159F54831DF3689EC83EE5C7496EAF0BC3309C85836BE8B4E5D4236B82F55D78A2CD3E7D4364B4FD7ADDE53DB954A33DD95DAAE704F64F4C9B2B542F3D56EB973D1AB';
wwv_flow_api.g_varchar2_table(32) := 'F5B4A6FB3816DED5694B7672A8B7D1A9C4526F4D1A5713AAA4A436D0F2C86054ECF75A53E971CFA6B11C63BDB5281BF7D426C7CB0773ABF4021F96473D9BF6C7699F943E0418100560789AE3FC6231792304A92DD42B4609E8E54096B0692300A319E85D';
wwv_flow_api.g_varchar2_table(33) := '48E8525B2F7A967652266F13AB02A5E4DA36808F689AD7EDF09C2DCDFD88BE14B1C86194237CA92FAB7CB547FAE0D067004BA85308CA3751E9561315AF32710EC17B052B38AF7AC1F8E5378C3FF7DF8940FDCD88B0F97D61352BD23321B4A23318E29526';
wwv_flow_api.g_varchar2_table(34) := '1AF980890ADBEBF4046C54367E75CA7895F78C3F7F82EB4B8035064DEE61D1717E27EDF727D7CD60A91BDA78F125E3554FC1C6EBF0348EF26DE586BC4B2B1EA699A8FB6B7700372BF89A794D2C261CBDDDCC6FBFD75447AF3171306A621FD76ADD2B2F93';
wwv_flow_api.g_varchar2_table(35) := '8AAA0071D1E42FFE8F299C791A604E02C8243DA5AE5552878E3ED5B700E72A53DDFA0BA6B2699F0947A42CD0B3D6AA369438B434BD70CE0473A74DF1F451134C1DE5711407C598DFF22B666EFBDDB59700A780A98F5AC1357BE10C3C5D30C1EC9B267FFE';
wwv_flow_api.g_varchar2_table(36) := 'DF51C0E335901512C457C782497B6BEBE80E60ABD16DF15013028288CE9970E280295F7107624905C351310E30627089F29B4D75EC1A00BBC68CBCF997C69B7F0B4026A0214B965061247C1B3A1F33E51DF79BEAF80D280AEED35AA5DE6EA62266F5FE31';
wwv_flow_api.g_varchar2_table(37) := 'CE78B1AC2988E64E403A65820BFF083D294D050B9E3061697BD2D2C6D994276EDB220A2AE2F1000A719B1979E7EB2677FE9FA181E7B1FCAC11E494A4A5DBF99F9A2A774EC852681EFF9AC9F25E6E2544124C54C132CE99A0FC8EF12B8A8358B02CAE3ACB';
wwv_flow_api.g_varchar2_table(38) := '6984306F3173577E8A73C5690951E052C2774D65CBA7CCA5EB7FD354266F4129F25859194B255EEBEDB2C2A206AE70B1AF1126F1F242E8D8442B1589B469DEF87AB6AACFACA523BE6C3BDB36F12A963E34AA63D79A995DBF8C72FD347CBC0771D15AA350';
wwv_flow_api.g_varchar2_table(39) := 'D6D89C0E562CEE2C78C56E5AB929175800C48AC94FBF86BB7B198BFA3142555C2C9ACAE6DBCDDCB60F6271B441C8316EBB32B1DB148B3762C56F52BF1597FD86A96EFE849945C851715BA20C508D83A205273F75029A6F514FD225B0B1ECA8B0D55A6958';
wwv_flow_api.g_varchar2_table(40) := 'DA463FC4ED0577CFA95508DE482B5BE7DC8BE64CE1BDE750B88B3C5BE23942C0D8F5F65C3CF9D54B26A4DFB92B7EC68C5E7A01054963FA4AC920FD74B1F409C0F24B7C826D2677F13F4CEEC2B78D3F7B8C3A2CC0265833363646F93FC2726F4DEAB1E2D8';
wwv_flow_api.g_varchar2_table(41) := 'CFE1B2B79A00803DB2E498FFF0B37CD5FD807B0520225C9E974204336F99D2A967A0FD5DDA9DA35E562F53015032E0A8B08B38FD53D039CBB5DCB3942D5BF02C28948745174F3F6DFC4BDF2671DB651BCC6FFB55337BF527ACB2E8BEBC4C75642740BF8F';
wwv_flow_api.g_varchar2_table(42) := '7E0159899763B79BE56CB573770077EC5A204002E497FF2F718108D026443537E7CD63D1B86B630470523CC545AC2A11E00CE0939C8D5F0788D45112704F9AD1D7BF6C82E9675120FE6B048F2CD99B4808008675C3B3AF98A2922325573E805882CDA824';
wwv_flow_api.g_varchar2_table(43) := 'D7B1A643FE76681063AB274DE1ECDF9AEAA63D667EF200CF3106E50AB931E2376D3465B2F3EE8E8593F0DBC65F770037CBA30D66ACE5D8690A02C1BD79E93C5753A71C563182D5A40B155894326A7F5EA0CFF13EE0EB70CFFB103E43225EC6B85B2F9CB5';
wwv_flow_api.g_varchar2_table(44) := '966BC1CDEF41FEC4691B3B6BCCE91AF7CF1E4E0D0C00B7FF6F866267F38004121F3DE3F1DE6E8E5EFE5AF83C0B0F8AB76ACF7DF167DBC8DDABAE990E553D2CEE00D6F83B2E085600E096E302D324BB5011E042B79138DD45CC7D9F15A062A717CD120F53';
wwv_flow_api.g_varchar2_table(45) := '978B9C8BD7E31699834AC0FA30BDCA4DBD69DDB22C3771B19A175F844BB9E06686014E450A262B5FB2082C9E95E50BB8AA5C3AFBB7397904D1A38E586D502C2D9224D3BBE67E68D6C3E20E608D5D9F760BA02456F7AE09473F6CCABB7EDD844C5FE486A3';
wwv_flow_api.g_varchar2_table(46) := 'DC888D7102CE4301FCD933A678E63B267FEEEB0818B7CA9C372A6851821525E6CA89A5F266ED9937B062AC0B77EAE111226BE5775AD70F2CB09B085F49547A9E9BFA3ECFBDCC2864C54D45F829E98B48D44229E35992BF4F13166EE25CC0F321CC04CC8B';
wwv_flow_api.g_varchar2_table(47) := 'FDB9377858DEA106FC22856AA29D5E7622C39446E6E80E6011ED585925B432B225431DD901C09308926B91B6C01146CBA74CF1DD674DFEEC53B42321B23153716F225110DB0E465006BF8A15C5C463B9EDF03CAB63BBCCECCEFB6857B2C9900555166735';
wwv_flow_api.g_varchar2_table(48) := '93238F8DBE491FD3DFE2BC66D149EF56D144A7B2E56E8C7C2F0A374A167D0D00EF23D11B833FF5A3E5D3C8E42F7C1F805F4DF85BEB6247C732B40C2FFC710B70C7DA27023581DBF966C55AACB2E538603E0B782119F2ECCE5FC26AF69AE2A9BF23FE6129';
wwv_flow_api.g_varchar2_table(49) := 'CAB4172C4E346A5292ABB6E071A85969B29205BD5A1B9BA8D97B29F3E951CF640AD6A9A95179C7C7A9A48D9D42213E7995488B308415C242E1DC2BACB2FD53C213B17AE5F5F20CFD2E9DBA05B813EDE359B95FE36F619EF92E56FA4D6B25B2889818ACA5';
wwv_flow_api.g_varchar2_table(50) := 'CBB07405E655B4AEB83CF2518E9BCCC889CF330F7E1B4113172DA010D251FF7B0A8024E02BE6EA7F580959B898071E94C85ABA94494C03927DACF66CAA200D4217F09A7665DC6EDA8F6893B917DF3B6E8A6F3FC97C9CC42FD0748BF12C49AB8170572FDC';
wwv_flow_api.g_varchar2_table(51) := '02BC8CF2B73602095A00E3EE1050F1D497903BF3556B9D581C73DCD99DBFC654E8276BEE30C7D4642F89D4BDA6F0F65F33EF3D6FEB63B262CF3EE7A3103BA0A7792874824D2C72FCC88C9EF89BC495134BC3D19BB0C8BB6B315956090B76FB70098E6D3D';
wwv_flow_api.g_varchar2_table(52) := 'FF6F5605B72F0BC6A2B528A3152E7FEE2C6EF9251667FE857AA64676B74BE0AE7F7107B0154EA703521C54ECE3185CC5514413ADF1669F37A57772261CBF2189CD58601C703D7623CD77DBA4265949629E2ACBE2531D27B32EED21A61EC50BFC04609C35';
wwv_flow_api.g_varchar2_table(53) := 'B9738F41933EAA478DB7F5B03157DE550335E9879B4B1665E1A23FF2160B1DE40136AE93B8F99553789013780492AF400AA50CBC3FC0D540DC01BCB27C96145A6325602A21D2169F5D7020234E4C2A99E2B0F0E155CFE10A65D5023E298A7DC6BF8EE4EB';
wwv_flow_api.g_varchar2_table(54) := '8764BFEF00280B0C7659719EAC79D2CCB1E130C2E28937779CEDE11B5880D8C37D36F1C9AC63EDE3AAD4F528B95EF4578343E988B5C1D4F3AC64FD0360EE4EEAEC5E308B1E79C2879D3EF50FB81A863B8045ADED8284D99B8D4A371257B79840EBB8951F';
wwv_flow_api.g_varchar2_table(55) := '404D498AF69510300B0AD5EDBF87F5224C049D044DC4CE7EAEDDB0AF9EC145BEC892E3CD890BD6B221EDE627F723F8DF25A67F0D17FD5F28C8BBD004AC902CD7FB394B47FFF9684B05C58A056481A9164AE82943D6D4C81EB5DEDC7FA54F00868D88694C';
wwv_flow_api.g_varchar2_table(56) := 'F11AD6757F1120EE63CFF715623116AB64882CBA4ABC9C671B518993D67CED2E114959300D50B27CF67EF3E79F3585893DECE17E883A6872DF4387E7B7BE1F57BE0BC539894BBD6093B9D81F81E6D500AC9090006C8116D87507B11831C55816593C8F04';
wwv_flow_api.g_varchar2_table(57) := '4E8B1E7D5EFA04604909C1620D517E92E4478BFF375B206C3CC5E54636234E16FC65B172CD8573C7D898388A0290B16A4AC29266892C5673D4F9ADB7729DB4F742FE373332714DB1128B138809B05E28CB4B1628341593E258574B1F692CD7510B23C9B3';
wwv_flow_api.g_varchar2_table(58) := 'E2551AB09216A84D7F14B7002786D0D9C8909B9DC6B01CC97F1559A7555B1E14784A620AE75E36A5934F60CD2C3D0A60BBD0C0C2083B4B236F7C81F9F103666EEB6DC46156B104903C01474B1B0A764AC6D1026AFBE1CEDC7B7CB383298EA73EB4E08222';
wwv_flow_api.g_varchar2_table(59) := 'B11B659FA38D1FA5F36D1703A58B1E14B700B7ADD4580731CD9F3BC1EECC8BA63A71131E76DC5A695606DA3C08CA9A92BCC232E533B870E2A99D92D462B2B257ED0B574F03FEE7598766FD7AF20EEB11A2E224F4984259B72A80A449244D95F3F47BCEE4';
wwv_flow_api.g_varchar2_table(60) := '2E9DA0FD0B84871F4283E5CF10F78E3BCFCD6A8E2D8B67AECBCA985DB19275D7DC7A96BF7E3C770B70DB8A0D4064A33E0B162327FF02AB63AB904F14B0888FDB54D1428257390318AF713C9958590A6E836415B30188B89CBBF82CF3E4EF40EF5AE8F1C9';
wwv_flow_api.g_varchar2_table(61) := '6DC622450F70B1687D9FCAAB9CA6DF9380A7E42B5134EBEEF10A8573DF24177891FABA427824738985D376008A5B803B1AB0AC0476B016BF4CE25466D1DF5A5BEAA62550EE2BB90988A5760200984B16E2AA1648B4FFCBDAB63C8399C3321BE8A5DA08E0';
wwv_flow_api.g_varchar2_table(62) := 'F6ABAF28855D54513FF208C46FE6CD72F949517BE2B6DD6D4A79AADD727D48597340D72DC06DBBE8CC4804A07685ECF4233B52114F3B10084A8ED2EBCCF3F654F5029FA3C06337CABA590B70B6ADDAA51F405D58A0501D7D5B65523CCE96E5942ADBA6C3';
wwv_flow_api.g_varchar2_table(63) := 'F35AF71D52B18FBB05388B47DBDC21404B27157C4A4895E9A7F95EDA267B541B95E5E8E95EEA6653C6D367744F45F7D336B6A2FB7F52561CF5E416E066F9B4C56496C852A3CDDE6FA5836CFBA5E88946B64D2B34BBD8C6312B6E83C972F2EBA23C362469';
wwv_flow_api.g_varchar2_table(64) := '8772740BB063EDDB90E0B5322887727407B043A65A91C1B04D6B127007B043B7D21AEBC356AD48C01DC0ADF4366CD37309B8057868C56E007428C7CE003E72BC1E79B5695BBF7233D0211563B2326E431E9D017C707FA26B7E94C0AB45F961E94C02A908';
wwv_flow_api.g_varchar2_table(65) := '25539554C66D52ED6CA123D5AEC8D77E9C7EA1A5C5265972CA669B6C5DA68F497676E78A3F92A94A2AE33645D219C00B9D7A3F6235E807665371BF395FD64F06EA8B43D973B56FBE5EA0D16727ABF1B9D2FD95EE2D37CCE499081906C890EF2B49A69483';
wwv_flow_api.g_varchar2_table(66) := 'CB3DD05A7D4751133DF3F4352575151F7DE80176D1BF6826F8A69B4A47942D85CBEB8F9522439E9A3FCF46CB6F79F73CF95509202BE37604D2310C5906E2A39FB913C83F095BECAEB31DE47716E2DB19D0403E13B1A1E1E96B251EE0C67FEFDDF3F87F6A';
wwv_flow_api.g_varchar2_table(67) := '1C59D9AEEBB8C4C8BA32B0013B7725D3FF078232BE989D36CB510000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72339765904797130)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/3gp.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000012E9494441547801ED9D79901CF575C75F77CF4CCFEC4AAB9500DD27E8F40A21B0454050294550292A7629C6854419A8E20F13FE48218E0042492595';
wwv_flow_api.g_varchar2_table(7) := '059C4ACA392A7F3855A910572594240C323948203E0338B1A11C631BAC45E858A10B74AD9695F69AABBBF37D6FE637EA99D5AEE6F8CD4CF7EEB434FBEBE9F99DEFF3DEFB5D3D3D447A0E434F36CDCBA5BBBBDB44E9A16F47A9046B6E9007A1201304443B';
wwv_flow_api.g_varchar2_table(8) := 'BE76DFCDA6616DF1C8EDC45B97886516D0C3F3503F2F6E45637D6DED6D2FFCF15FFFDDB157B66EB5B6EDDD8BEBB9F604B4E61555AB26C045701FBAFF1E838C17E2768CE1C2146ACABAAC46B056555B8A6824189BD1181976FCBB86EBFCFE9FFCD5373F86';
wwv_flow_api.g_varchar2_table(9) := '2547F07290B54429AB22018E54AD7CA449798D77FEE8E107E639AEF183B6B8DD359C4C66F0A1C919D702C02FB3CBE573B96BFE34EA5CC553215FCF9F1B306237128B8FB677764E771DE75DC734BEDAFD177F7B743241AEC987EECD4B31E378D7C223AF1A';
wwv_flow_api.g_varchar2_table(10) := '4DA5F88A09099A9EE7E5433EAFED95CBAF388FCB5DBB5C392A9E0A390E71DDC4F88D0857D8719DA144227E8BE17ABB9F7FEAA965009CC5CBCAC5E118E13D6A02DCD5D5C5C600C95B8687AE98DD322C574EF0271FAAF7410A79D850F0EE16E01BA3A3492F';
wwv_flow_api.g_varchar2_table(11) := '61DB1B3D3303C88F4C1AC83501EEE9E91117EF1A8E87138829B49A6E42538D6432E9C46DFB56D7B4F674EF7C62395BF22BAF6CCD5B7B38DB56136065C1ECE75840E114016A6D90C7EE867D4C3295723096B8C5F4DC3DCF3FFDE88A6DDBF63ADDDD9B42EB';
wwv_flow_api.g_varchar2_table(12) := 'AE6B02EC071A5EBAA29DAAFA62ADA3A329B6E40D9E69ECCE59F25BA1B5646D80A533F6130FD3392C58AA8B91214213160D770DC8317B035B3243664B0EA3BBD60658994098B816EA5A183D145A2196CCEE9A211BAEFB72F7938FAC16C85BC3D5276B033C';
wwv_flow_api.g_varchar2_table(13) := '292C386FC879F005C8185DDF6459D64BDD7F08C87BC365C9DA001774BF6016213A196BC1AAF205C8B66DAFB79C3C6476D7B0642875E09BAD0DB092482843D507175BB06ACA58C84F6EFF1C5BF2B61040D60638D42E5AA11C3F14C829F4C96CC98669BEFC';
wwv_flow_api.g_varchar2_table(14) := '674F3DBA76AF82ECF13240300F6D8083D9BC4A6B3521A7DC62082027E2F65AD7345EEA5690B76DE3A5D90913575A135DF1B5010E64EB2A96D215FD9058324FA160C96B8D1040D606F88AA2A958D8CD4850969AE6E7C9492761C7D65A80FCDC33DB6F6077';
wwv_flow_api.g_varchar2_table(15) := 'FDECB3CF1A58DED426531D12D05699B244A3A3C6F5C8A3308A2E5B4D596E663295CEB2257BAEF1EDE7FE60FB8D80EBF2FA7C90206B035CB668EA01A8D63C0BA3E80A32E2C56BCFB3B018924DC4E3ABB1A1B6E7B99DDB6F644B0E12646D80436DC105AE15';
wwv_flow_api.g_varchar2_table(16) := 'B6A214B263ECE97EFAF19B18326719044BD60638D4165C005C452B4A209B86B7E7B9271FDBC0EE3A0890B5012EC828D427155AB06AAB0F3276A15679160506B236C0558A4689A8B96161905543357C90B176BD9C2CDA1D044BD606B80AE75683343527AD';
wwv_flow_api.g_varchar2_table(17) := '669075B92AF820C3925730E4AFEFD87E7333DDB536C053DE8215701F64DB8EAD703D4CA19E7AFCD66641D606787258B0A656E421A7304F8EC7ED659E89815793206B033C392C58632B0A960CC8766C296E3D6D0A646D8095870A6558E8833559B01282CF';
wwv_flow_api.g_varchar2_table(18) := '92E1AE9792E1BEF4F5671EBBBD91EE5A1B60CDA251220A7FE8871CB797A04FDED3FDCC63BFD928C872677FF8A5A8AB051A5DB4BF4A7EC8766C512A95D9D5FDE4630F00F28FF3DB8CA602EE4FA6E35C1BE03A8946471B2BC883FD509D5A2290C9E28117DC';
wwv_flow_api.g_varchar2_table(19) := '3520A777C15D3F80CB80CC55ECAE0BE4968B2EC25F27B8AA0CFE660F362804722CB6C8F568F7B33B1EFD2DDEB68005F34B1B0F55A4F60C55C6E10C1B3092C85B723A9DCEC0921782F9AEE7773EBE19F2F2FEB40E905B8059130B4B9575B660A5F5F21D3D';
wwv_flow_api.g_varchar2_table(20) := '8AC09219F27CCFF576C192EF40E9DA2D591BE006894689486F58AF6952492D19A0BA84132E35924A02722C360FCC5F7C7EE71377E27386ECEA72D7DA00176AAE5A10A6505930BBCF3A1E02D59F3F5BB241D1545A065EB0647737BEF0761747D105591B60';
wwv_flow_api.g_varchar2_table(21) := '7FBD43750E3B320CD365B67871C8DF346CD8CBCC956581711ACB9AB3C932FFE9CF773E51800C59D6A474537A9AC450BDAC632587879230E2219F076D8A8E8E8ED090699A7386B3CEDF3CFDF08387FEF21FFEB9772B6EAE5777885453296D80C3EAA21D27';
wwv_flow_api.g_varchar2_table(22) := '6B6746325636EBF074B4266BA90640711A2F8A2A3850BC35B82577213EEBE5EF60037071B40ADE6903DC64C954D0E4E2A810A61131CCA8113528EB3898A6E6282B85E576F1B90A39B5FF9CDF8F77A8782AE478FE7395EED235031EDA24075A87FE38AB3E';
wwv_flow_api.g_varchar2_table(23) := 'AF25D4065809A496CA342BADC74F6581BBB64C4B20F3CD542C743E54BB54E8BF261126F8A3D2A870BCB4BECFB1F681DB04B8EFC897AC1E93314131137EA46D90A504326169C1FD90AB6FE02676236A592C5D79CFD79AF02A92927A4C46D1C50ADE68035C';
wwv_flow_api.g_varchar2_table(24) := '4199818E6AE2095F802C75F45956A0EB3C51E5B4019E0CC250825290D97CC3DE2E6D809570264B3859206B03CCDA3ED90E3FE4B0B64D1BE0B0BBB2F1002AC8FC7918DBA80DF078029A0CD715E4307AA916E03235D00F394C96AC0D7018B5BB4CB685680C';
wwv_flow_api.g_varchar2_table(25) := '398229549846D7DA008749AB0BC4AA38099B256B035C85AC429B244C90B5019E0A2EDAAF910A320B30C8DE4B1BE02037D20F46E77918FA646D80750A2E4C79294B0EEAC0AB0558833609E48885E71007CF5D6B033CD5FAE052BDE0FDE4082007CD92B501';
wwv_flow_api.g_varchar2_table(26) := '2E6DF0547CCF90A301B3E41660CD9A18344BD606782A8EA2C7D30D65C94170D7DA004FF53EB8147650206B03DCB2E052C478986500FA646D805B163C16305F517D320BBA1946A00DF0E59BD7BACA1268A6256B03DC0CED0C93FAF0ADCECD98426903DC72';
wwv_flow_api.g_varchar2_table(27) := 'D15756B7026408AB5106A10D70A32A7C6531063B8640C64D032CF846C84C1BE0960597AF58054B6E00646D80CB6F5E2B264BA051905B809BA86F05C875EC93B5016E447FD24416752BBAD027D7A98FD306B84EF5AB9B608394B182CCA17C415963E5B401';
wwv_flow_api.g_varchar2_table(28) := '6E59706D547290F1934CB83557A72CB5016E59706D8039B5B26430D67668FB86BFB61A4DF18C1832DF5CCF5FF4D77168B3601D9569E59193806C506812460BB02641EACC46671F1C4A178D672C57254F19A52265B5E9B95095475515283391C62E98B401';
wwv_flow_api.g_varchar2_table(29) := 'AE4EE465B6B8245A34668BA0CB2D93058627E950369391BB1E239C5EAE95643CC15B15DFC966C8C3E3965081096207E7236D801BD35C4C215C872E9C3B4D4E360D195FAE8761ECC5B5618BC5AF76D3B4CEABC8C5F9C5BE3362C59558A3CA2331BD93A2B1';
wwv_flow_api.g_varchar2_table(30) := '584D5EA091F8B5016E44A53DCF252B12A5256BD6518485ECCACF0396F2BC5495BC893348178A71FED4A76462843A6FE9B5A21C0557ADCC53859C83FF9CDF220F2E7FA0EF1C8D0E0F111E3978A99C009F8506305B607A64883AE62EA42FDE7B3FCDBCEA2A';
wwv_flow_api.g_varchar2_table(31) := 'CA64B21378CABC15C3622DDCAB9C4A26E9956FFD3DB5B54FA32DF73D48916894DC82AB5556AF9C7E3E6D1E1C2B8205C5C8A4D3F4E61BAFD17B6F7D9FA6CFBC5A9426C06CA56AE1010C93721D97CC488466CC9C05C0574B9F3A1E617E4E2FFF6738112B42';
wwv_flow_api.g_varchar2_table(32) := 'A95492A2D118DCAB4D9DB366899BC5230311A51826F7D69CA74ACF525280B90F6F9F369D9C4C2A67E19256294530518706B0882FCF825D33BF5CBCC6EB47F9B9930C900F17EEBCEFEC19EA3B759296AD592BD7408DC9E541E52F21E022186826932EE4CF';
wwv_flow_api.g_varchar2_table(33) := '65B1C527474769A0BF8FACA82D7A90FF934B1CD0BFA101CCFD5F2412A3349EB97B60DF07347D462700C245170996D771F10F40162E5D064BBD8A1C9C737F79ACF730F59D3C4AB3172EA1431FF6C06D47720039BD50E5900771501EFC5BB07809B54FEFC0';
wwv_flow_api.g_varchar2_table(34) := '602E2B5E835DF4C10FF7D1C15FFD9CDAA6CF1025282A3AA06FB401AEB7A312570B4B1C1D1AA4FF7AF94501E1B75EF91C2E9847C88B57AFA57B7FEF1101CBD7870707E9A30F7E49B1443B9D39718CF6BEF0CD1C20D10EFC411CCE8BDD7FFF274769D3571E';
wwv_flow_api.g_varchar2_table(35) := 'A0C5D75E2706CAE96370EBC73FEEA51FFCCBB7D10FA7A8AD2391EBBF030AD55F2D6D808B2DC95F449DCED9DA0AA68732306562254B2787A96BC3AD34EB9A6BE4C9B111403B75F2381DFD681FD96DD3C43AD380E4AF2F438CDA713A77BC97567DE136BA65';
wwv_flow_api.g_varchar2_table(36) := 'D366198CF1C02C66DB7471E0337AF3F57FA7F39F9EA01957CF15CF51A75669CF561B60ED351B2F43808DC6E2E24E0B7D20C85AE823472E5EA0259FBB9156755D2F83A8742A252E965DF2F0403F4D9F758DE41A0768642387B2FC91C18B34FFBA3574D73D';
wwv_flow_api.g_varchar2_table(37) := '5FA539F317C8A89B95C3858B7EF7C76FD2BE77DEA60EC0E57E5F34C9AF21E3D53500D7C331992B11948BBE975794B87F9417DEF3946778E01CAD5C77135D3D7B8E8CB07960D47FEE1C1DDAF73E14202673608EC76979449CC5B4870127478631051BA44D';
wwv_flow_api.g_varchar2_table(38) := '5FBA9B965EB79C5831043C00EFFFF5FBF4BF6FFC2B253A66CA5E2DCFA78BCCBFA46E417BAB0D70BDFBE022C1C1FCB8CF547D300F985280D4397B3EAD5CBB8EE26D6D3282E65D99A3BD87E8CCB15EB2D1FFE2F789848DA4C5192F7AF06AD8E0F933B4F177';
wwv_flow_api.g_varchar2_table(39) := 'BE42376CF80D298647DF763C0ED77E827EF4DAAB9401703BD1066BC6B40A7986E9D006B899CD36F1A4F6E10BFDB462DDE731FA5D2C7019FAF0D0101DECF94006463CFFCD59DFA59A721C5EF65C8D7EF7B6CD778A62B0F572BFCB03B3B7BFF7069D3CB49F';
wwv_flow_api.g_varchar2_table(40) := 'DAB1C4C99E224C96AB94501BE0865AB0AA3DDC2B4F5FD2C9518A63856AF5BAF5340D531B76BF51C0630B3CBA3F37B86238EC76F9E090FBECE10B03346BCE7CDAFCA52F8B5BE741155FE7A9D27BEFFC847EF93656AC66CD46024C9DF00AE3A10D70331ACF';
wwv_flow_api.g_varchar2_table(41) := 'B84CAC528D5CFC0CEBD3D7D312F49F0C8FDD6806907B3FFA502CD46E6B17ABE6EB0217F079BAC37DF9E62F6FA5652B57117E4B509A1003E0C348F7D67F7C87A270EB9168A490B6196DACB5CC500366D79CC58A13835BB3FEF3B2B0C1A062982FF76353E0';
wwv_flow_api.g_varchar2_table(42) := '10DCB389CD09EE6BD92A79F42B9B040887CE9FA55BEFDA42EBB9DF8552F0A209F7BB674F9FA2FFFECF7FA3A1CFFA29816549D96254FD6ECE01D42AF386A6D706F852CFD698FAB3259AD8441819BC40F396ADA4E5ABD60848A1882A1C3FD24B9F1E394809';
wwv_flow_api.g_varchar2_table(43) := 'B86C0F6BD872A0920CFB62FF59CC7737D2ED77FCB640E579710CF3E0E4C808FDF4CD1FD2910FDEC3806D9EA46325E28D0E7959109782DD9866D65C8AB67970A3959B2D51A63C80B36A3DA64673E6CA6E4F04D3A161AC761DC6B2627A741803A459E4C0AA';
wwv_flow_api.g_varchar2_table(44) := '79F3C062778EF96EE73573E98E2D77633164767EBE9BEB777FF57FEFD24F5E7F951233664A5EECC2C5ADFBC4CCE5F2B5B01CDA2CB8910D16EB8525A6B02F3B1383A4955DEB643991A737BC7374FAD34FE8C8FE5F537C5A87B85F563EB6DC3476945CB8F4';
wwv_flow_api.g_varchar2_table(45) := '3BEFBE97962E5F291099150FD43E3E74907EF8EA4BE200F8C7A9B2A9115830E6D77C0787BC306746C8EE3C4C87360B6EA44EABC1520A16BAEEB64DB460D162CA40F8B2678BADBC8F0F1EA0FE5327A873CE0299DEB07BE55170263942B77F11F3DD2FDC2C';
wwv_flow_api.g_varchar2_table(46) := '73625E95E234594C81E28904FDEE830FCB7662E98859140AAE9A2DFABD9FFE0FEDFFF93B70FDD870E07E3DE08736C08D6A676E141CC5D46844161F565F7F83C01945FF19C76244DFD9D3B27225832B40E1F92BFFA25912CAD0096BBFF1968D32CF4D61BE';
wwv_flow_api.g_varchar2_table(47) := 'CB0B213C3766A39CBB70112D5CB214E7A516CA236F568408142143470F1F14D7DFD6D189311BAB7569FC4649A2BC72B4016E543373FD9F07F73C48D76FDC442BD67489FBB56181BC767CF2D8513A7EA087DA67A0EFCDF7A12C0A76B509CC95A77574C86D';
wwv_flow_api.g_varchar2_table(48) := '3F315C2BED4BF97EADD283B734F8E02D4409C74691EB41FDA30D70A35C342F2DB25546B0E93E67C1221AC5FEF0452C58F0BA731A0B15FBDFFF854C9D78B0A5A6500C87E7CBBCE478EEF46999FAB05B2E059CB3C6B12DC9B968F9D148B91F2BB7E11F0ED2';
wwv_flow_api.g_varchar2_table(49) := 'DA0037AAB9AA7FB4618D1FFEE2677418735DB6540698C588FAC2F93EB97B92954001E4BE92B703794AF5FACBBB441972F98C85399E25E69CB147830303D2FFCAAED2789103745D1BE046B649813BF7C909812A83284064C8BC296060E084FB638BD68E39';
wwv_flow_api.g_varchar2_table(50) := '0D8FB24F1F3F22D32BB9E76AC24AFB553687171A43B1789BB8F87AF6BDFE9227AC62191F8612B06A17EF10F16A13779D3CDDE1503614E4828A752964C87CBB8D28481552E4247C5FF6D881D8A532749C95EF57AE5C5AA801B39B75B2954D55E456D92BCB';
wwv_flow_api.g_varchar2_table(51) := '65D2C4D0B6D0A153EB268D7403D0106D80ABF07801687E30ABA05396DA00B72C589FB2E894A536C0FA9AD7CA49A704B401D6E956743670AAE7A50DB04EB732D5A1E834166D8075566AAA03D6692C3501EEE9E991BAE07E43B9A76DAA83D1D57E36169629';
wwv_flow_api.g_varchar2_table(52) := '1F4AC6B97795FFAD097057579718AEE959064ED4C64BE5B568A518230196295F54321E13A1CC0B35AD6429ED720DC783A660815036D50A41D1627099159A301A37B9DABEA096B45C2995BE349CB0C2F90FCB4D23377DF22E33D6E820534EAD645C4E3197';
wwv_flow_api.g_varchar2_table(53) := '8B5313E0ADC8712F5E51CB38E2B8C681846D770D2793F8D22ECB835B5587A3966C6B49CB4D51E94BC3729A394E1AA6C81FE5F5D6850CAD9164EA40D4F28E70B64AC67C5ECDA18AAD262D574AD6F839F18E87EEBF07505F88DBB14E7ECF8055E5F97DD08E';
wwv_flow_api.g_varchar2_table(54) := 'A0D54D7C1F84944CA52EA06E0F7DE31F777F8765E697713532AC09706905767CEDBE9B4DC3DAE2910BC86665BB00D5D47E52A571F1884A73C0F58CD7BEF1AD177F562ADB6637B566456976030258BE1699FE3F81A0AD660428E6470000000049454E44AE';
wwv_flow_api.g_varchar2_table(55) := '426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72340069419797131)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/7z.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001343494441547801ED9D7B6C1CC77DC77FBB4BDE1D5F12F5A2249A92288A922591F22B961BBB4150B84851208081161181D801FA878DA0086A5B6E64';
wwv_flow_api.g_varchar2_table(7) := 'C529FA60E4142DD2070AB4FD276ED1249564C774FE488002458D38A983384EEC00AD1B5956AD975529962C4A941452BCE3DDEEF6FB9DBD39EE9177D4F16EEE6E97E20AA7D9DB9D999DF97DE6F798D9BDA58899CD32534DF36A191D1DB571F5D8F763AE04';
wwv_flow_api.g_varchar2_table(8) := '6BEE900FA1A0122422071F7FF401DB721EF1C5EBC6574F84328BE8E6FB689F9F725A13E3ED1DED2FFCF1DFFCE3072FEFDBE78C8C8DE178D09F88B67C51CDAA097011DC271EFB8C25D60BA9648270A10A35555D512738AAAABD8A1A91606CB526C44EA6FE';
wwv_flow_api.g_varchar2_table(9) := 'DDF2DC2FFCC95FFFC31968720B3E2EAA56592A6A488433552B1FD5A5FC8877FFE8F39FDBE87AD6ABEDA9E4D0543A9DC5499B15D702202CB352F5943A162EA3F7753E9DF2787EDF82127B2D89D47447777797E7BA6FBAB6F5D9D1BFFCBBB34B09724D3674';
wwv_flow_api.g_varchar2_table(10) := '2C2FC5ACEB0FC022DF399DC9F0880D09DABEEFE753EED7F609EA2BAEA3D4B152D7D1F974CA3CC2B629E5B75AD860D77327DBDA521FB73CFFC8F3070E6C05E01C3E4E908739E2BBD50478686888CA00C93B960F574CB30CCD553BF82F9FEAEF514A193614';
wwv_flow_api.g_varchar2_table(11) := 'ACBB03F8D6F474DA6F4B261FF2EDEC92825C13E063C78E2913EF59AE8F1D8829B623DDC648B5D2E9B49B4A261FF4ECECD1D1E79E19A426BFFCF2BEBCB6C7B36F3501D61A4C3B4701C5530468B5253ECD0D6D4C3A9371114B7CDCF6BDA3CF3FFBD4F69191';
wwv_flow_api.g_varchar2_table(12) := '3137CEE6BA26C061A0F1A5AB46A76EBED2D6E9E90C3579AF6F5B47E2AEC9C6002B671C261EA77D68B06A2E2243A436341AE61A9013C9BD614D8EA3B9360658AB409CB816DA5A881E0ABD509A4C734DC89E65BD34FAC53FD849738DA9A13A57281BF11D63';
wwv_flow_api.g_varchar2_table(13) := '80978406E71539CFAC0019D1F57D8EE3BC38FA65401E03E418055EC60017C67EC44774C9E6CDD7609DAD0039994CDEE3B879C8794DC6A08E7CB78D01D6128965AA7D70B106EBAE1441B65D1BE6FAC9DDD4E411986B78ED4843360638D6265AA32C9F2AC8';
wwv_flow_api.g_varchar2_table(14) := '19FAE464EA6ECBB1BFFDE7079E1A1E03E4B11142E6324034376380A3D9BDC5B66A414EC1620820C3270F7BB6F5E228202B4D1E19892C6463801714CD62E5DCB4FCB7B4434A933985824F1EB6F290A9C92311856C0CF02D45D334688BB97045C3343F4F4E';
wwv_flow_api.g_varchar2_table(15) := '439313C30E201FFAD293776BC858F53226D3C5B4BC5C5E638DA94834E55AD1ECE38540A9E2614AB9D9E9CC4C8E9AEC7BD64B87FEF0C97B0999EBF351826C0C70C5A26936CC52D72F44D1A54E9639C6C56BDF77B018926B4BA576E286DAD143CF450FB231';
wwv_flow_api.g_varchar2_table(16) := 'C0B1D6E002C345F6622E64D73A3AFAECFEFBA8C9AC320A9A6C0C70AC35B800B88A5ECC816C5BDE8B87BEF8F45EC0E5B35D4D876C0C704146B1DE59A406EBBE8620639EBCC377E46854201B035CA568B4889A9B1682AC1A9AA1204BE09393C94171E44814';
wwv_flow_api.g_varchar2_table(17) := '201B035C8571AB419A868B561364956A029F58CA075E78BA743B217FF5E0330F34D35C1B037CDB6BB0065E30D79C4225B67BE2BE74E8C0FE079B05D918E0A5A1C1867A91879CC13C194F866CF56DFF68B3201B03BC3434D8602F429A0C73DD8F474F8F1E';
wwv_flow_api.g_varchar2_table(18) := 'FA72E335D918606DA16299167CB0210DD642086932CC753F1EC07EF1AB5F7AFA138D34D7C6001B168D1651FCD322C8C92DAE2F84FCC94641564FF6C75F8AA67A60D044879B14820C73DD07DF7CF8D0B3CF3CF6A7A3A33FCADF4BB635F0703113FBC600D7';
wwv_flow_api.g_varchar2_table(19) := '493426FAB8883A6887EAD41305591C065E30D79B901E81267F0E875F57D60F77A1EA0179D94417E1AF135C7D8DFC3C59414E2436799E1C1D3DB0FF615CD5075C7E8CF1D097345EA1AE389E69032289BC26CFCCCC6493A9C41DB6EDFFEBF3CFED7F18F2F2';
wwv_flow_api.g_varchar2_table(20) := 'FFAC0E909701732416962AEBACC17AD4ABDFE8490B34390B73DDEB7BFEE1AF1C7CEA37EBA1C9C6003748345A4466D37A4D93E6B49200F521ECF0AA2D99B482BC11CCBFF595834F7F0AE769AABD7D78DB80CE5B4B6A0C70A1E5B5B4A65965B506D37CD671';
wwv_flow_api.g_varchar2_table(21) := '5350C3F553932D69CD075EBDB8F861FCE0EDB79985F7944DF8646380C3ED8ED53EF4C8B26CFC3A05B2B62CA6FCA561C33E76702D676626378365CD1E71EC6FFCC573CF28C8D464C8B2A641775B4F9308D5CFB94E7A6A320D259E0C59D0A68CD1E99B3269';
wwv_flow_api.g_varchar2_table(22) := 'DBCEFAA95CEE6F9FFDFCEFBDFF575FFFE629986A5B3F21524DA38C018EAB8976DD5C327B33EBE4722E7F5A5893B65403A0B88CDF8A26B81878BBF0486E1FCE9DE26FB001B838DB22BE1903DC64C92CA2CBC559214CABC5B25BAD564B72AE8BDBB901653D';
wwv_flow_api.g_varchar2_table(23) := '60D92FEEEB94A5C3FBFC5E6ED3F974CA7CE17D5D6EF698050B6D8B8B5187F7C3E4F4F95A526380B5406A694CB3CAFA7C2B0BCCB5633B0A72D8F1E97EE9946D0CEF2FD4669D4FA7E5CA86CE7BD877D4DB4CF257D1AFC958E83A0B9D3316647114C67863F3';
wwv_flow_api.g_varchar2_table(24) := 'F19323CB6A751C86D278A98C5236759CE71AF82912A37E4D46D1C1457C31067811D78C74561B6FF802E492A634D20D2FD33863804366A6CCA5E2737829413606383EF82A6BE952816C0C309DD452DBC290E3DA3763809792890EC3D490792C8E7D340638';
wwv_flow_api.g_varchar2_table(25) := '2C94A5B6AF21C7D14A2D03AE70348621C749938D018EE3E8AE906D211B21B7C46C0A650C709C46758158153B71D3646380AB90556C8BC409B231C0B783890E8F480D99028CB2F5320638CA9D0C8331B91F079F6C0CB049C1C5A92EADC9B460511CE4CB80';
wwv_flow_api.g_varchar2_table(26) := '0D8C2605B9C5C17B88A307D918E0DBCD07CF1D17BC9FDC02C851D3646380E776F876FC4EC8AD11D3E465C0864762D434D918E028061886D9555C9DD6E428986B63806F771F3C977E54201B03BCACC17311E3659611F0C9C6002F6BF07CC03CA27D3205DD';
wwv_flow_api.g_varchar2_table(27) := '0C253006B874F7968F5202CDD46463809B313AE3347CF83399664CA18C015E36D1B71E6E05C81056A314C218E04635F8D6628C760E05190F0D50F08D909931C0CB1A5CF9C02A687203201B035C79F7967352028D82BC0CB889E3AD00B98E3ED918E046F8';
wwv_flow_api.g_varchar2_table(28) := '9326B2A8DBA50B3EB94E3ECE18E03AB5AF6E828D52C51A3253F50365838D33067859836BA31240C69F64C2A3B92665690CF0B206D70698A5B52683B1B1CDD82FFC8DB5E836AF8890F9703D7FE86F6233A6C1261AB35C4720017583C2903096011B12A4C9';
wwv_flow_api.g_varchar2_table(29) := '6A4CFAE02563A2F1DEE59232569169C933B307CB959DCD31BB57497DB3B9ABDB33E882C518E0D2E2ADAE83D5946A6969151BBE4BB78342F27D4F72D96CB0E85B4A6AFCF3DD28C3B22AFF0217D6C5DD5C563CBC6E0911D102B9A373CA18E0A67617C2BE39';
wwv_flow_api.g_varchar2_table(30) := '794332F85878CF1437CF73A535D9266D5D2BC102C7F40BB042B267DE6C262D372E5FC469C05E009AD27274B2ADAB5B12C994CA1FAA2AB2BBC60037B387D4A8D5EB7BA56BE7B0D25AAA31B519AF289489CB97D43105B9A0DF416BF1BE31E958D12D770CEC';
wwv_flow_api.g_varchar2_table(31) := '50703544958D2396E6209F6AF8D7AF8ECBD4F56BAAFE66F6B9D26BC71630613830AD999B93926CEB904FFDCE3E19D8B15332D0486EADAD09B90110FFF6D2613973FCBFA5B37BAD7839BC3C2E6F6AF04E48999C1897A1BD0FC9C39F7E441C0C08CFC52BD0';
wwv_flow_api.g_varchar2_table(32) := '0A5A1C32F6D46E65197CF9F1F75F95FFFCEEB765E5DA0DE2C10560F4542AEBA6E48B2D6072E2AA4F7AEA5732307C8F82DBBD7A8D6467320A920D202BBBBB65DBEE6139F9CEDBCA64AB5522BC475F410448373B23A9B67659BD662D064B0B5F2138ABC90A';
wwv_flow_api.g_varchar2_table(33) := '5C301A38986C2730F36D1D1DAA1C070ADF96166DBC622EC86AE8F084542DBE7670262BD4C4C15D4342C14FC107E38C824458A9B636E91FDC212BD7AC97F4F414F274490E80F3D8541D34D39974BA08700B607380CCE22349BCF0B0A19D3473B1586A3045';
wwv_flow_api.g_varchar2_table(34) := '4D933A3D7543566FEC93CD03836AF5C7CDD98297782A4DA44652F3D6F7DE217D807CFCAD372405C0DA9706E20B022B6A67003438FAE185F372E3DA04AE41F1F04D96D060046A043C7EF14349B677AA633C1EF5CD18E04676959028DC6C7A5AFAEFDC253D';
wwv_flow_api.g_varchar2_table(35) := '1B364A0EFE95502F018E07C81BFB36898B631D9D9DB26DD7B01C7FFB0D7C87C663607010146D683CEB63BD0CD8FEEBA73F911F7CE7B0ACDAD0A706CBAC262BFBA022F379751455189D2FC19CC2407B02B367A0A25B55416D52E6398369504AB6ED1C9254';
wwv_flow_api.g_varchar2_table(36) := '7BBB02412D3CFFC159B970EE6CC1973238DAB26D5056F5F4AA2951104D2F7C116505E09F69E63D98F02075D580E1E089D3660C70233BCD6029039FDAB3A95F366D1D50FE9170B3998C9CF9DFF7E4E4F163823F5BA34C2C357BDDFA0DB265C72EA5F15CFC';
wwv_flow_api.g_varchar2_table(37) := '2836D3255ACE489A7367E5AD833FACC05C364C36AD449CB6D801A646723AC3087800F35E46C059AC5651F0D7E137CF9F7A5FCE9D382ED727AEAAC89726971A3E88689AE69953A560E1A33CA6442221DD3D1BA50B517857F72A4CB15649D7AA35D20E73AF';
wwv_flow_api.g_varchar2_table(38) := 'FC6E23FD51F9665674C6D8706C489FE92701298BA89701D3B69DBBA5153032D05C4640172F5C902B17CF23BACE60FFBCAC836F56DA8A729BFAB7CADADECD72F5A30FA5AD156FCE9FB7C1FF62F58B03E8FE4F7C5286EFBB5F055EAA5F28DF8232573EBA24';
wwv_flow_api.g_varchar2_table(39) := 'DF3BF20D99BC3E218954DB7C5F3EAFCEE61F3006B8213E98A613DB4CFAA66CD9B5477A376F867FF494F666B319F8DE33EABC83458EFF3B735A76EEB94BAD33D34CAF5ABB4EB6623A75E9DC294C973A15481516AB1230C6A10E74AF5A2D162C03D4559DE5';
wwv_flow_api.g_varchar2_table(40) := 'FFAD004CCDD7411A0D7770365F4144136326BA119DA580957906B0C1DD7B64C5CA6E0046F40CAD9EB87245DEFDF95B7213DA35833F5FF2EEDB6FCAD5F1F1C02C23304A24936ABEDC9248AA604945E265A0F01CEFC9529BF951FBEA3B47013F8DE86D99C6';
wwv_flow_api.g_varchar2_table(41) := '2DF2B0310D5EE475179F5D99674BB2D369E50FB92C49B0D44E6ADAF5890915F1F60FDDABA0646E4E293FCC79B08209C8776CDE221BFB07E5E207A755041ED6DABCB22A1F3B7EF923CCB1A78A4D349645AFE038A36ADB0EE6D88BEF44E34BC40730694071';
wwv_flow_api.g_varchar2_table(42) := '66D25332B8E75E2C60F42AF34C7884CCEF8F7E61BF5A90A092713AD3CE65450E006CFCBE02C1D2E0D05D08C27E211DD0FEE22913A75FB410AEFCECF51F16E6C1FCAED7B0689669CB5BE0F7198DC76133069886AB6E1BC0AAE8194110A3D8ED437B941FD5';
wwv_flow_api.g_varchar2_table(43) := 'F078AC13B70557C27716AC271AC4F9ABCEE3210FFDE8C09D3BE5275CB224F8B00A871ACFFA187079F81B28B3F35ED58840AB713E2E5B3C7CB0521C9867DC295A8DD5A5CD58B85066372F6846B80E961BA96DBCC3A33ED8A74606C1112A405E2E606CE8ED';
wwv_flow_api.g_varchar2_table(44) := '93BEEDBB70176A4AD5510A94F2C130C3DA070769F0101C074D9C36631A5CD74EE7358DB706EFFEF5DF9035EB7A0A8112619C3F7B462EFEF28282A9E6A9680C8F67B1D8B1168B1C9C22F13BE1747475C9F6E1BBE4D43B3FCF3779BEEDE140C8A67F25EE4C';
wwv_flow_api.g_varchar2_table(45) := '5A0D1A6D16A8B75C45133B51D7EE9AACDC18E0F96232D74CFA3E152D23D0E19DA32496286730D7A576A6A7A7E58DEFFF87BC76E4EF65DDE03D6A0ECCB6382D09B97AE1947CECB77E57461EFF7D98F01558109951D134EF307562E1E2EA2FCF01BC6E27D7';
wwv_flow_api.g_varchar2_table(46) := 'B7835B89F7FCDA83B215A65CDF6C600E1A0BDE651AFFE8A2BCF6DD57D4AA192D871E50BA96A8A5C600D7B363D43E4E7DD66FDEAA22619A6025581CBF76F58A9C7BFF3DC0BD57DD0E74530CAA30CD8179EE19D88D95AD136A81A26BC50A55865ABCB6A707';
wwv_flow_api.g_varchar2_table(47) := '4B97BBE5DC3B6FA8BCF4CF163EF4B7BC562FA2EDBEFEAD01550656F9308B03EAC2B96EF921B4983E5A2C6832C947788BBE0F86C0B9D13C0F3FF0905A57E69FA04BA6524AA3689A2F5F382B6D9D00887F04CB7747924B22D52E93572FAB1B103C9EC2EA13';
wwv_flow_api.g_varchar2_table(48) := 'A7560CC6863EB6177F79745AF9592E4D269209B52AC69531CE7B39800274F9340F3248A20D353CDE8C697080215CB5997DD64BF3CC87E7F884C6C49571F856AE3D630E8C35E893EFFE023982AB17DDC2538030A5C1837727DFFD1F3CF171A77A7A23875B';
wwv_flow_api.g_varchar2_table(49) := '8604DA86F5E99EEDF763D9F11ACCEE25E55BD552657E40855BAFCD304DF2B52B9715FC5BAD6787CB3773DF18E07A8D692D5C6AE39BAFBD2A6FBDFE03150D33B2E514880FC17576AF510B10730549601C18E74F9E9057FEE5EB4A433908822997276D78E0';
wwv_flow_api.g_varchar2_table(50) := 'EEEC7BC7640C7E35D8D88BF24355056E58F77673AE5A1E8DC35CD818E0B9C235F99D82A5302F9E3B8DBB48590588E0A945C9F60EB51C59CE17B22C7DEC25AC536B0DF531BFE5531CBC6191816F3FFFFE6534772E5CFD5DA78127E65D2B3EE4C77AEBB5F1';
wwv_flow_api.g_varchar2_table(51) := '8AA6B65800D69D2510FA52FA412D5E4223B0C2019D39947220B4435BC944955529822A045C04D6D18D9B0BA1FC6577594E2D7ED4772E5C515BCA36B2F844AC00D3BCBAF8CCDB6E2911C20C962CE79655C154997373F3C6F1BBB128FA96328EA37496409B';
wwv_flow_api.g_varchar2_table(52) := '8D0136E93796805C6BEA8249591A03BCACC135312D2A6C5296C60017B570F94B6424600CB049B31219E92C818618036CD2AC2C01B9D6D40593CA620CB0C946D5249D2550D8A4B2D404F8D8B163AA2DC1FD9BFCDAFC121070B3BB4065D1B3762DE36ADB54';
wwv_flow_api.g_varchar2_table(53) := '13E0A1A121A5B8B6EFF09794F1788EB45A4935B81C65CA4B6A19577BF99A56B2F4E8F22CD7C748C12AA0BAB55648165C3FACA6C5EC72B5BEA096B26CAB2E3F37ADA41F9596517729B1C60E5152A6AC5ACBB892CB94CA5313E07DA8710C9F56C73AED7AD6';
wwv_flow_api.g_varchar2_table(54) := '89B66472682A9D563FC0554F2096BA62ADC728AC6AB75ACAF29ABAFCDCB492F69429438A3C951FB71E64E8DC4C674EB43AFE6956AB65CCFD6A367DD96ACAB2516AFD9E850F3EF1D86700F5855432D1CDEF04AC1BCFEF51DBA2D63665FB20A47426731D6D';
wwv_flow_api.g_varchar2_table(55) := '7BE26BFF74E415CA2C2CE36A645813E0B90D38F8F8A30FD896F30896F601D92E7157A09A26DE2E653C3C87625FF37CEB7B5FFBE76FFD6CAE6C9B2D859A074AB33B10C1EB1B91E9FF03C8B29D294F2532BB0000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72340484409797132)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/ae.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D0000119B494441547801ED9D4D8C1CC515C7ABBA677766BFBCEBB50D31060218B08D6D30041C99444908424A0E4151C25A8990924B2E91724814620C4262';
wwv_flow_api.g_varchar2_table(7) := '95534EB9E5048AF20136617340E1028A60D741209143A44008E1C310071B12F062AFF76B6667BA2BFF7F75F76CCF78773D335D33D3353325CF7677755575F5FBD57BF5AAAABB2D8481A09490068A696B116A72D2E984FBA81662A63AA2DE630A454AA198';
wwv_flow_api.g_varchar2_table(8) := 'EFECB31307B177AF506A0C5B5F0847FFABB7CC9AD3E30ABC44BD81599452BEAF54CECD0C9C1D18B8EC3179F7E42975D384ABD4941FDD4FBDE5A6317D22CD8BC39D7D66E23E507E7C6CA47F94370A21A53F284F28679328CAF1E7D0207F3870D72FFEADA6';
wwv_flow_api.g_varchar2_table(9) := '2733E22B935EA7404E84413D3DE1CAC353DE27CF7D6BBB5370FF3C3E9ADD3B7BBE5084C16E40AF5ADC1E149B60C977FB4797378D6E1F592979AFE47D79FFE60E839C08C454C8C42F88EB9450BBCECFAF4075355C969BEE9F54121627035B2D8A457F2137';
wwv_flow_api.g_varchar2_table(10) := '3270674EAA27974F3C72ADBC6BB224662661AEEDF72D12019E98D8ABFB5EE9B9D00674C5813DE05F2B7EBABA52BA689CB230BFAC72C3D93B855AE928C889004F4DBDA1659471A10EF05B34578DBCC5E636C1E5E06C31B7F6A0F3F3792F373C708890F32F';
wwv_flow_api.g_varchar2_table(11) := '1DBD8E9A3C63B92627021C6930256413DD781BD4A6464AE538180AC006E51708397748F9EAF8DC899FDD7017CDB578DADA215422C0045B19B4425746A5F0285E4BC2861607033DA5FD8600F250EE60BF729ECC4F1FBD5ECAC39EAD9A6C18700A69D65025';
wwv_flow_api.g_varchar2_table(12) := '28AE76A7B0216FC8049A3CBF0C4DCEDE0157EC1821DBAAC95D0F98DAAC35B8B22138F419F30B052F37A4211FCFBF78641735594C4D5865AEBB1E3055566B7025601E513632BF08C8C3D9DB7D473C55987E6837C7FD62CA9E3EB9EB01AFA3C111EE003234';
wwv_flow_api.g_varchar2_table(13) := '796038774049FF7800D91E4DEE6AC0DAC1A29AB20F5E3F94216787B21AF2FC89237B024D4EBFB9360C782339AD2FC1769D897BD397A8430019E69A90334AFEA130FDF0BE55C89C064867300C38B5F75921FD7833ACA3C665C8E893F72B5982B97E20847C';
wwv_flow_api.g_varchar2_table(14) := '188E573A211B061C175D854C537510875A678D03C898F1CA0EE5F6F9D2493D64C380E3A24B15D38ACAD409B5222F0E1CE184335E21E485BF3C7033CDF5D4D46167120F0E546768E771AA2AD32A41C49B21F7EB36AF98F182417630842A615A739FEBBB4F';
wwv_flow_api.g_varchar2_table(15) := '2D9E387AEB61407EF4A637249F0E69D5BD5CEA3A862B9250372E55DB269C678D2FE145AF7955895C681A2E26430039BBC7F1D5B11540D68E578A201B061CD78D35E5D2619131C823D9DD5E1CF2A3C09F024D360CD83E0D2EB7B806AA1EAC345E04F9F8CA';
wwv_flow_api.g_varchar2_table(16) := 'F491DBA59CF4450A201B066C8706C759966B5CDE2923BFE48E46AB0BAB80BCCB13F2F8E2CCD13BD200D930E04BCA241509AA59D6ED64457701B8441B8410F23CFAE491ECF5AE504FA6017257028E90704B056CC4C9D26594E106E568DC3270BC30E37583';
wwv_flow_api.g_varchar2_table(17) := '03C84B2F1C39D84E4DEE7AC064D4B0066BCAC19F55D6A126730805C832238F2FCD3C74A85D90BB1E70220D8E01AEDC8D411ECC5E27857FAC5D90BB1E30C198D0E04AC03C8A411ECA5E530199D76CD110AAAB016B0758A3D870B990B41A0C559095777C79';
wwv_flow_api.g_varchar2_table(18) := 'FAC12FCA490CA1105A01D930E048640DCAA3C5D956FB4D4ABB59178F411ECE7D16F3D8C7965F78F04BAD829CF8E5B34AB16897A5322A8547BADF0DEB5586DCD4AAC7200F65AFCA2FAE3C519C79E87EF995C997D83DA847B97C1168B5697175A50697A142';
wwv_flow_api.g_varchar2_table(19) := '9A4D53DC8B48C521F75F55121EDEA08026EBA74926C1B9390B148601C74577D11DA626A27550AB6F390679307B155EB085B93EFA55C4A24ACD816C1870F50DA5F378CD66D832EA21E4A5952256A176888CFAFDF289E641360CB8655232DA72F430694DEA';
wwv_flow_api.g_varchar2_table(20) := '462F132B8C904506EBC9C5DC60F60A5CFF89E5178FDCDD0C4D360CB8A5528A09ACB1DD7273643F181E70C355A2BA7F35E40B93E8B2B10F612940CE170706B3DB852B7FB73073E41E42A6C3F534DEBD469AC4C130E0B2C81257AC5505E826C907E6286E7E';
wwv_flow_api.g_varchar2_table(21) := '8E0217E69FBA7F35E40B930417D137A8AFD2A79F0C8126BB423E81D764BEC6537C3AC4C438D930602D2E5DF534FF899AA1AE2DB4D7910EBECBE108D7757DBC65C8370D5BF3E3B5712DE94A7765B9B882C77F2EC380E937C5571ED190395666A34B224BC3';
wwv_flow_api.g_varchar2_table(22) := 'E3E02455695D5E4A8C9009D5F356DC0BF39FE67D2517E8CCAE25CF28FD5A358CCE45DBEA34EBC5335D742EDA8A0B6AA12FE35E5E982BFEF23F4F7DFF9DABBFF3DB935378174A08BC2ED360E84AC0ABB28268FD42B658CCBB78125679BE90784D38EA2357';
wwv_flow_api.g_varchar2_table(23) := '9371AF4CA132BA7CB4D1F9F8B9F87E39331B1B9A97527D38EDA1127B1C2773254E9F0CDEC18E3E9611CB50E36ED702D672861A43B032D72FFB28E085BC2F7CC439863BAE1A5900B014FD1947144A5EC9F33DBC789E3C742D608A8E2E0EBD651FCAD30FDD';
wwv_flow_api.g_varchar2_table(24) := '19C223CF65C83C17CA978D8161AD63DD50706EA36D2D79990665E0DB5DF0A751B3E85AD1673278BE91D0A6B6DA48559B938790D9F1D299C9428F877370B920611FE65A77C8E139EDECB083AE3A8EE237DA46E736CACB34808ADAF022AB21FE998CD5D8DA';
wwv_flow_api.g_varchar2_table(25) := 'F7BA1E705C5410B2C866A400646DA679DCD2105ECFE4650D033659B5968AB67C31DE41DB20C755B75CA3643B860137A186C9EEAFA1DC6D85DC508DD7CF6418B0FD1A1C894A4386E3D50E736D524D0C033659B548D4EDDBB6BC4FD6FA413FCE5C300CD85C';
wwv_flow_api.g_varchar2_table(26) := 'C5D252524B3559EB8749BCC197640CCAD26CE50C562C51515A93DB64AE13551C990D6B706799E8B8706D856C1870676A7004BA1A32A7358D06D3E5A172860177AE064720E390316DBCF6C24494B8DE6D13C4671870BD776467FA32E401AC219B865C3151';
wwv_flow_api.g_varchar2_table(27) := '995C3E3DC00DCA9090FBB12C306C12B236D166ED740F708380998D288C43EE697002224DC8AA217381C28426A77F1CDC04095A50A459736DD6D3EA9968430DC89C26F7FA604348CC17A335D994B93654BD9E061B1264544C0479A4E13EB967A22359A676';
wwv_flow_api.g_varchar2_table(28) := '4BC87DD0E4C620F74C746AC1C62BA621639C5C3FE49E06C7E598EA7DEA625993F1A611A1D7124C22EEF5C1B5483C419AB2B9C6837C994B410E1B408DEDA0A65AF500D724A6648922C87CFC6743C8A1EAF6343899BCDB92BB66C89800ED69705B1025BF68';
wwv_flow_api.g_varchar2_table(29) := '35E4B5D7934DEAAFF1F5E0E442E8F412E290FBD0275740D6AA5BF966435279F4FAE0A4126C203FA1F671A9117D7205E450797B26BA01A1A6290B391222875011646A7633424F839B21D51ACBD4E69A932115DE75AF0FAE517C7624E3472BF13FA86BC834';
wwv_flow_api.g_varchar2_table(30) := 'DB7809DCE8927F4F83DBDC0E22739D09CD356157385E09EBD7039C5080A6B2D35C73128473D774BC4C85AE7EC3DF94104D95A3FBE4703DB98437D04D841E601352345886D6647C62A0CF3183A667A20DC2315594C91193996662EACE8C95B39E88361A82';
wwv_flow_api.g_varchar2_table(31) := 'AC9727AAD44679A334E9DB76206080927DF855DD9A429FA68A20500D92C73064B21F3F1A341E57C15C372F92A63C544921E5B5ADA97A70414BE731C97B0EA923771470650E6EEA16C4451059580857E14372A58F7198471C45126F04CC9B4551C82B595E';
wwv_flow_api.g_varchar2_table(32) := 'FC1C0E531E3A0C30344FAD0891BB1AAF1CDC8A7DC0D10150FD2521F26770C4B8484311AFF0BD310700073E0788D896F304397583F00B42143E445694ADB53C3A97FE6D87008656D1247BCBE0D1279C9DDF1572CB6E6825C090253DD2C2BCF0DEFCB510F3';
wwv_flow_api.g_varchar2_table(33) := '7F07C8CD8804589AE5D22C3EABB347B8BBBE27C4F0E5388616C735957997CF0AEF9F8F09B1F42EF28E226FC39F8E6C798BE810C0941B019F1562F41EC0DD25E4D0D610300853EB06C7851C3F20D4DC2B803486F4248F1F351E8D420C6E1172F832218A68';
wwv_flow_api.g_varchar2_table(34) := '24652D45C3C139FCB71988431ADD289807BB96840E011C9A5A985F67FC6628E690D6580D821CF5E0322B1C68B5771A5AEA434B1DF4C93A101888F9D04A0F4E18013BE86B19C740AE3CB75A1863AD09908CED81DA45ED9D43DF7BA3909B77061AA99D2980';
wwv_flow_api.g_varchar2_table(35) := '619F4A6004347285909B6E06B0051C933CCEBB23D82C0AFF8369A13E7E2DD05E9A65E6C14F7DF20F9C9B81F25EC0B981A03CE4B4257400608A1AAB30DE392147016F647BA0712EE02C9DD53F0D931F9FEC1F86F9BE05E96196E96CD17B760603C0EF3D2C';
wwv_flow_api.g_varchar2_table(36) := 'FC8F5E0EE2357CECF2E8A357857FF2E7003C8FB4D47AE4B328580E9866149A062F57BA43E863F706E6D9A70305C0E74EE2F70EF6A9AD0CF8CAE8E61BE0615F8D3C1C1269FB1D6C9D2B71487B5C1518E7C0ACC7D3562549F3A1E58029779A678C7907770B';
wwv_flow_api.g_varchar2_table(37) := '39766D008240BD15C0FD9750B330BBD8D790D1974A78CA720C43280F6365ED4C05F02541969DAB1832C4E973B1289B762D071C68A0528B8006E76A681BC0C151A2E7BB3C2BD4C2BBF09AFF86F98B1026FBE3CC00CC344CB9CE4AE72928438F8723C7AA82';
wwv_flow_api.g_varchar2_table(38) := '6068CA2BE2EC39B01870E45C016E661BCC33C6BD80A7B8CC060D56731FC0933E2D54E114F64F8108CD7910B4A60FEC426358440401E35736E361A2F286E7CA07D6ED580C98B246F5696A876E8283758DF67025BFC74FF37CE17DF4B32BE88AC7853A8F7E';
wwv_flow_api.g_varchar2_table(39) := '586B36CED14C73CCBBF936F85898E458CB2C5B8771FD0A5B0C1855E73423863A72F37E8C60C603882ECCF3D227429D7D15A7CF40A30B18EACC04DE3467A868A6312529B7C0218363169401155D55F0F5A565E1194B0147E619E3D9FE1D8005F38CB1AB0A';
wwv_flow_api.g_varchar2_table(40) := 'E791393CC247F9851CF9029CAAFD38D70FC0584C8805397A35347F3FF886FDB3C56638765B17ED5A3A9315D050FEBC70463E8FC98B1D5A33F9FF2009FC672572D395C2DDFF9355F34BF07DD0563D230519E058E6C6D03060A62FBC84882B2E124CA74458';
wwv_flow_api.g_varchar2_table(41) := '0898B694635FF4AF30B9721CE639BB49830D1C62C0CB8E6175884B83B140B87A7C8C386DA6FBB563263FE0D425273E208A751D2D4B0D1DEECACE9AB32FE57463EE1A40BA31B80D6D9EA1D9E88383FF51035ACBB8E847E78BE7D80A741CF6F4D4E56D681C';
wwv_flow_api.g_varchar2_table(42) := '9FE200E7D61C26218BC51DB4851A0C500484F55D390AED1DFE4CA8996CAB181E9D7B1F66F734201366E839D1A2437BE52087533B910C69790CCD975B0EE0D980694C459E12D2E3EC562C301FE254F14D0CC5389BC56BE0DA168D9B2C034CE78ADA8B755E';
wwv_flow_api.g_varchar2_table(43) := '97131670A0FA3097CC15A00CD676B1F54F3D2FFC333F05BCAF231D16F9F53008794AEF0B31FE6DAC2DFC3834E9981071737A782587F609B9ED47C2D9B63780C706C480CB393BBE8C86B143F81F3E8F29ECFF21020B0E16CD475B069852875AF998A018D8';
wwv_flow_api.g_varchar2_table(44) := '194C4D46261820F5E2C2FC5B807E0FE061515FC2B1A216EAFE15FB8B58B05FF82F4CFB18AC3186572438B815E5DC229CEDB743BBAFC5531F5895D280710EE7E5564C880CA13FFFF8654C9C9C0ACA8C1A008B4E79A0CDB128A0BA00A3F0EC94DC7A087D28';
wwv_flow_api.g_varchar2_table(45) := 'BC676A28B598C3A4F93378FAE26D98533A58D042ADBD384FC8D03C85A737FC73808C7899411E6E0978DB81302D12F2B11D5A036EF9D34B8D919808DDAE6099061330578E46F5C486C2A334FA111BF6B79CBD9A7D1DE731F941B07C5243930514ED3C71D1';
wwv_flow_api.g_varchar2_table(46) := '202BD4A7AF61660BA63D83A53FAD895861CA207F712EE8BB7D98EEC89B663E1722C2BCB6603C2DC1BA8E583AC15B06988B03E84FE1F1FAA7D1277EF86200490305D8022633E80CE9192EAA2D43B485463B184E2DBC2DBCD77F857D686985C344ED8CD232';
wwv_flow_api.g_varchar2_table(47) := '1F03E3D05808B788C6E4C0CC5BF43C16EFC032C0A8B1D62E089E0FC0692DA5F9A43906786724D85680E36D868179A9B54BEF601B5B492244B20D351A3B388860635F973D8C2DAF6557B00F70245F3EDDA8051EC1C056438B8EA384555BE6C960DE3A201A';
wwv_flow_api.g_varchar2_table(48) := 'DB329DA6CC9D5808E3B45588455BB26B2F609A4A0DB45E49B321B03F8D34B4DEFC76A5B7CFE618916F77C0A5A8BA14B091566245213DC056606ABC923DC08DCBCE8A9C3DC056606ABC923DC08DCBCE8A9C8601730CDA0B69924022C053536F94C71BD801';
wwv_flow_api.g_varchar2_table(49) := 'DDF2619AEED1AABA544B302EE3466E2411E08989BD5A654B5EF082658F7123086279B49604569032E59948C6B15475ED269AC98A5A97723DD4CAC157F8749D5843FCB8A96E8F75D5AD1B13F34B860C2A90A910918C1B154622C013E155F10584F74441BE';
wwv_flow_api.g_varchar2_table(50) := '3536D2BF77F67C014FBDF1440F6EDD5094F021437776AEF09653824C112219D75D5698211105B43689051ADDE6669F99B80F3B8FA382FCC6417949B5D18A755BBE6899F9FCFCCA1CA0FC60CB37A7FE4819C465DC884C1201AEAEC0D967270E02F7BDA815';
wwv_flow_api.g_varchar2_table(51) := '9E8971B02E8790A897D72574F61F2D25FC91909494E7B1FDD3D66F4CFD95379D14AE31C1B122C60AEB15A425604AA6FF070930D174CF82409C0000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72340943264797134)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/ai.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001A22494441547801ED5D798C1C557AFFAAAB7BBA7BBAE7F03DB619DF6363F005C60663EE05DBB08B954DD64E94B0EC4A59254AB44A94448BB48784B5';
wwv_flow_api.g_varchar2_table(7) := '602CB1BB5112925D299B3F3604EC5D26221257D80404018C6DCE051F1890011B33BEEDB967FAA8AEFC7EAFBA7A6A7AAE3E5E4F770FF346DD75BDE37BDFEFBBDE57D535223A8A2D868E6ECADAC78E1D3E9908F3C862A23FEB38FF43DB36C4306C365CFDE2';
wwv_flow_api.g_varchar2_table(8) := '7DEB6DF16DC561239895AA64D84171CA32241436CCF3D36B6A7FF9DCC61F1DDF76C51366ABBD9D74ABF9E4CF8CCA6B519CE679C05DF5C27DDF307CC62FCDBA50A39AA6515CD7B9B18A3814368E61DB62A175444CA94BFA9E1731FFE2F90DDFFFEC969776';
wwv_flow_api.g_varchar2_table(9) := 'F85FBE65873551402E8C3B69EE6F7B0212BF7DBBB5F6951FCC4E26ADFFF537D65E996CEF49E0B2CF617CE100A487486F86EB67B873835B39476E3D778BB30017F41929B153117FA06F6AB4AE2E95B0F6899DF8E3E737EC9850200388C24BABB4AAC65632';
wwv_flow_api.g_varchar2_table(10) := 'B1083BCBACCE3E308FE0F2637BB6DC2FE6E3F6E7ED63B873DEEBEEBE5BCFDDE2BC817D3816D0A95C14C0EDAE69A8DD20BEC0E39B0E3CB0F0E55B77246F79798739117C324128BC6CBB92AA20366C33B482BE1847FCAA864F1A62D866121DEFECB3FD91D0';
wwv_flow_api.g_varchar2_table(11) := 'F53EDB37A1402E0EE0D6C3CAC41B760AF127C2167544C8ABA7A40D372268DB4876F55B81BAF00682FCD537772D9A089A5C1CC0690D762C1D3458E973F580EBA1541921EA74A2ABCFF247431B2C2BB5E78EFD0FB410E46DF244D52EA18A03D8C32158B941';
wwv_flow_api.g_varchar2_table(12) := '47557540DB43E174E2075793D79BD0E4CDAFEF5AD26A6CB7AAD5276B04B87AD557C10BF94CDB201580253AA1C975A17588B57713E46AD5648D0057BF067B66A040A64F5620FB527BB6BCF9C0326A72B5996B8D0057A106BB24D340538307FB1507E46E80';
wwv_flow_api.g_varchar2_table(13) := '1C0D5D635BBE5F6F7AEBA1CB074086BE5741D1087055CC7730242EC9E9F8DF3DF454227F8C24400E44436BCCA4BD2703726BAB8ABC3D752B725723C01539BFD189725576F4F8DF0119E6DA24C896BDE7F67D0F2C67066F5B1580AC1160975BA3F3B4A2AE';
wwv_flow_api.g_varchar2_table(14) := '7A5516E48F3283B4B98E596624B4C62FC66F36BDB973453580AC11E08A822E3762BC88026C2FDEC374005E39C9107F5D78A599923D9BF6563EC81A011E833DC370ACECA7BC248FAEC12EA999E81A9ABCC2F07941DE5E913E5923C05E7570F95145DBB135';
wwv_flow_api.g_varchar2_table(15) := 'D89D4C06E4409D03F296FD3B57B56E6F854F06C87C70A0828A4662BCEA504133CC85143793954B5DA78E0F8B241FA2EB24418668FFFACED77F7C9502F90AE4E72B08648D0057B1060FBF0E1E15EEB4C29B0AE46868B96D98BBEF7C7D57C581AC11E02AD6';
wwv_flow_api.g_varchar2_table(16) := 'E0349405CC804D4C64BC92C8785D6E23AD79E79B0EC83BEEC7950AD0648D0057A1067B49C6BEF77054F5752F3A0DF8E880D2640532EE426DD9FBE3753B8C1DA94A005923C0EEACAB68EB5559EC7B0F739A051BB820BB9A1C0D2D139FB97BCBDE5D1501B2';
wwv_flow_api.g_varchar2_table(17) := '4680F3664F4E3C1C974AF9075903640D4CDBD164C75C2F31CCD4E395A0C91A01CEDBC00D30A9DC7BE9204B0319199091D66C314C13F7931F5C5F4E73AD11E00151D6C0A8F1EDA2180D1E4A69C6272319D282C7D5F66C39F0D0867281AC11E02AD4609764';
wwv_flow_api.g_varchar2_table(18) := '7D1AECC24D6937933D88AE23A14578DE6B77B940D60870156AB04B72FA76A18B8EA6AD17E405E5025923C09AD8329EDD7835D8DDD73BBE07E4E00249D97BB6EC7FF0069A6B35CC38AC9335025C1A0EE9E577566FAE06A74F976806699063493C19321F8F';
wwv_flow_api.g_varchar2_table(19) := '17EFDEB4F7C19B900419179035029CC5BC6A38F4220A18B2F0D6398334C8F0C9B5C1669F693CB6F9C043372A90EFBFDFDE6197EE068546804BC81E9DACF6F6E52519607BF1F656D3B4EF80DC0D4D8E049BF1E3B7C737BD014DC60F067648E940D6087089';
wwv_flow_api.g_varchar2_table(20) := 'D9A389CB237603F67BF11EB15E7117D24B2807649F4573FDC06D0EC8D0E31268B246808B9B79595A7B65B2F41AEC4E11201B5842C512F0C9737DA6F91F771ED80590A5249AFCE506D855592E93C64783D320F3915BC39FE8E94FC05CCFB1EDD4635B5EDF';
wwv_flow_api.g_varchar2_table(21) := 'F9955268B246805D6EB9825A05DBB406AB5F34646B30AFE5F3E174C7AA2FCE9B101C676FF327982EC8B3C5673CBA69FFCE3B94266319B5ED896DFCD563D14523C09C5D7516A5BCFCF2263C28AFF97C38F5B1EAF3C7316E3DB5039D1509249DC06B0E9E05';
wwv_flow_api.g_varchar2_table(22) := '7A6CF31BBBB6F0129F0ED1713F5923C00EC5D5F60D50A14ABE9401561BA6812D9EC6C9E5E3CBB1DE587DB11F9F615A7DB178201A9C69DAF6AFEE7AFB6105B25A467985AE00E616FF1296CCA08E70660E2B7D070687A026ED94D9DDD3D30FB3D95D7692BB';
wwv_flow_api.g_varchar2_table(23) := '7ABB7D7EDF2C2B61FDFDDAE7BEF7F1DB77FDE4D8B6D66D3EBC4981AF1329A86804B8CA4C34E4912219B7AD603C9130A52F89F7EEA418E10EBF206665778ADE7D97EDDE73DE7D5EF71E7BF7DDB6E93AE83E8060DA820559EEF31997E1F4B156F51B6CE755';
wwv_flow_api.g_varchar2_table(24) := '19DEEAB9EE6B049894575971B4D8901A7F4001DB970488388937520CA0C939651F7BCFB9D7DCADF75AF63E8F59DCBA83B70CC10CBF5FECA495B413368829BE680418D4555B71F94B54030C4710B82A909126A62667CA707373CF656FD9C83D97BDEF76E8';
wwv_flow_api.g_varchar2_table(25) := '5E1FBCC58878F18F6D626B38AF8741FDF46B32DC96F96E3506595E86E44B4619EB3B643B778403E06D085692CE39A5164FCE79063AE3F001DC8A1A1776C595CC6B320AE39146800B23A0A25A91B3D4E450C031D3EA7D5A154561DEC468047890DCE54D48';
wwv_flow_api.g_varchar2_table(26) := '45359840206B04B8A2202A9E980902B24680ABD4078F260A35604FD835D7A355ACDC6B1A019E4026DAC5CBF5C90A649C2CB54F2E010B3502EC7265826D07810C2B550210321C2B81119C0438C3DD517686805C22944BD0AD46804B207EA3F07CDC2F6540';
wwv_flow_api.g_varchar2_table(27) := '466E8899AE5298EB12B05023C02510BF7147718C013320BB8197E6396BEE8EB3D108F018CC99289709821F6CCB44D71A51A96C0D2E0175952C145C272B90B12D85B9D634778D1AAC5192354DAEA4DD70BA0A648D3EB9042CD4087049D959999D67402E91';
wwv_flow_api.g_varchar2_table(28) := '4FD630EB49808B65E220908B34D725F0721A012E0175C5327FBCDA6740D668AE35D1AE11604D14556B37199069AE8BD4648D3C9804582333551A5377E055247D1A01A6084F960CC8B59511786904F84BEC83B3E59AB2CE6448BE2097404734025C02EAB2';
wwv_flow_api.g_varchar2_table(29) := '19574DC785805C021DD1087009A8AB264087A3D50BB2095697410734023CDC0C27CF2950DDDC351F881D2DAD590201D0087009A89B28F2A13419E03277AD3479045E95C0086A04B804D44D1480398F5C41D63C678D008F20959A09AEEAEEF85E1D9AE9B1';
wwv_flow_api.g_varchar2_table(30) := '3459E32435023CA9C163E2E2B2C83F02C825D0118D008F39BDC90A2E07A8C9C381EC0A805B4FC37612600D4CCCBB0B02394E3E5923C025B02F7973AECA1A0C01593FFD1A012E817DD13FDFCAEB7110C8E0A1663DD108B066CA2A0F8AD251E40599BE79B4';
wwv_flow_api.g_varchar2_table(31) := '64489E5468FC01F8A406E7C9FBC1D5DD25145E3620491C24F4288C468007D33B79942707A81F194D062CA13CDB8F507D12E0111853B6D30499E94C4D8FAC6BF4C16563C9041C588F7926632A5A83394DBC95640880EABF430E393BF804DB0D6D3950C78D';
wwv_flow_api.g_varchar2_table(32) := '18F8924A777FE0AAB397DDC748E30E4727FB64FDC24AA1ED868EA611E0D1D83974E0B1CEB0B71A30286CE0DF31E38F70B9DB5EDB92843A1EDA0BDBD12CD51B01BC33878CE21997612E8D78C70ACE27F189DB29B545A541B5D8368AB1BD7DC4C4923ED477';
wwv_flow_api.g_varchar2_table(33) := '7B631BF618C2FF990DF10D3D3872C637405F4A482763276F7D1C8E6BD108B0BE69904984F5125E15F556B213473CC3FE9D6D8B59AB986FE1D83B2AAF92CD712C33F65A1DA8CE17C4B9EDB03BA8F864AA2F20CD468DD4F9FCAA4D3F00A4D611D47EB47DD7';
wwv_flow_api.g_varchar2_table(34) := 'EA421F2E4436EA05A5C517422D8EE45043213C69C5A42DD58B331C8B1F1512CB0A3382379B19A8EF9CC566DC8B4680F5D14E0653FA9BC0CC9B43B3C124532C30DA076625B03D1ABF289DA984629EC36A676C6A2EC1ADF599724F709E447C35AA9D63841D';
wwv_flow_api.g_varchar2_table(35) := 'E1202CFCEB83F01CB77AE4B5443B962471596246651A00EF47FF78FB9D34A0EDBDA199D04E3FDEA864E326904F4E27BBE4A344A704B1CFDEF0F634B9682764993F2A5FAB69564458A8EBC7755A8883B1F3D2918A2B0D27E4E528150930B5E25D30FF1733';
wwv_flow_api.g_varchar2_table(36) := '37CA9D4DEB945625C17432998C7DF28BBDF2B7E75E91B500858C737D650882F03BAB5BBE5E335BBE3BFF2E69AE9D21312B9EF185AE3050C7E2A9A45C4AF6C8F9FE76F95DE7A7F2AFEDEFC9DB56AF6C30EBE45568FF37C34DF237F3BF263382F59240DD1A';
wwv_flow_api.g_varchar2_table(37) := '33202F9D7E57EE697B46D660DC08803F61F5491442F1BDE62DB2A671B11A8B2086CCA01CB878545EFBFC3965AAA3B0473150C971C7BB5414C00480DA7106266F79A05EAE99B2542E8BCC943840E2356A628DE9976BA72E93C885FDD0424B6A01AAA31DB6';
wwv_flow_api.g_varchar2_table(38) := 'F2BD84BB061A3C3DD4204DE1A9D28FB6EA4DB21ECE42C9D09F2D9719339134B265DDF4E572CDC51679E4E4FFC8FB716834C60902B819E14699159C02614848D0AC912981281A5AD05CFE37775B4EA6FAE49F2084D7CF5821615C8F5B49A9F507A5ADEF82';
wwv_flow_api.g_varchar2_table(39) := 'BC7AE903F90002B31E663A5E267039E58A5A2691E94190F419FCD9D6E862991D9E86370BF64B0F3E712B21BDD8F626FAA19933E54F6AE7CB9154BF029D9AE16A27C1A149ED4FC6513FA6DAF7614BA013290B6059F089D079D489A10EFBAD8539BE69E62A';
wwv_flow_api.g_varchar2_table(40) := 'F9EBE6CD32C34486211553AFEE663B8EEF6E63009AFD33A8DA07FFFCAD688BDC050B53036DEE887563DC949C8F75C8A3C75F909F5D7A031626AC02B87299E78A0398BE37060D1130705DFD6269A88928204C68690C3ED387F3A8228D3551B9BEBE05A8F2';
wwv_flow_api.g_varchar2_table(41) := '7D9D4E74CDC9780BCD393F6C1384796DEBBD20FF05D3FE74DB3E79F9CC7B72B2F71CF20918117E9DE05B00FEAA292DF2478D2B45001EFD3DC7651DA72F539DC34BA5E534046B0104E19BB36F94B97003FDB0381C8375F79E3B243FBCF8A6ACF24F43B0E6';
wwv_flow_api.g_varchar2_table(42) := '5326BA1CA6D9E58546133DA0436EE7F96CE947B92CD997EC962DC126595AD7AC189484B6F558FDF245DF796989CE55AA8A57EDCA8A8605B2EC6CBDB4C33FD6A35D7621352A9C82A6FA014A1B00FDD689FF84CD8286A2FED6E00CB96FDE57E5AAA92DAA1E';
wwv_flow_api.g_varchar2_table(43) := 'FD6C2D7CE7151857CE8694B65398A8E92CEC4B056BD0D28FE17B1F69BA5DD64E5D2A095800D6A881893E78E913F969DB8B2ACB184564DE0901A4D096B36834D1C54EC4599ED03CDE5CB758F9CF2418E407A3CEF55F927D085AE80B9DF784DAD09CE97277';
wwv_flow_api.g_varchar2_table(44) := '649162B61FDAE644CAC3B1926B683E0A85A9FA6AE57200BC0E9FA7BA3F9267CEBE255DC93E25000490A51ED6411044C53176769F1C5BAC4EF9767489DC357B1DFC349657100CFADF53F0BBBFFAE225793D7E5E057FDDB044E50697F3D10830BB2BAC280D';
wwv_flow_api.g_varchar2_table(45) := '003BDBB1A410F8AD35F58B24E20F2BB30944E544CF5979FCE27BD21EEF562697BE2EEAAF956B1B60A6A1E1F4B9238A57FA02C162D2844B986900786660AAB4253A14C0045F692AEA52DB8380C6EB3795F6828E24C014ACC1EF9D7D93CC094F973E98769A';
wwv_flow_api.g_varchar2_table(46) := '666E9F3975407EDE7948AEF337AA255E619CD0DFAA4200B6C17C530E21EABC277C992C8ECEC14C099A4FF9B7A3DD27E5ADFEE372BCE78CD23382411F79797DB36CAC9921A720184C8C0C5BD22696FDF5A583AB1EAC5DCFC2CF4E47841B812FA5805090D8';
wwv_flow_api.g_varchar2_table(47) := '39FD71CC467F3C56A3D1EDA7AFC182EC9C71B35C0DB3CEE0CCF5F1FBCE1F91BF3AFB8A5C812516931AF837012351332C89A53CA91160C7C415422CB347640AEC9F6CA85B2433428D6AED19C092E82CD6A9EFF49E04AF6D39D4754201407099F898159A2A';
wwv_flow_api.g_varchar2_table(48) := '9BEB9660B9D2AB962E238D4DA854FF30AF872144AF22B9D10C0DDE347D8D34046A9599A539852D90D3FD175099C90CBC799D53626314AEC36721AADFDA742D96617E8C6FC17D98F241C77179047E97951B9928C11C485FA594A1D149C19415362906575C';
wwv_flow_api.g_varchar2_table(49) := 'CBB621125DEA6F9015F50B9028A851CBA1206E9B9D80D61E41E66A66609ABCDD735C7E0F66BA293C45994BAE39D7362C16B978006B4D0BC1CDE0E9288AD2C2300D42B36BD626C744FB231867BEB4C00230B8A2C9AF0D8411C85D9057DA8F82034E049E09';
wwv_flow_api.g_varchar2_table(50) := 'AC708675AE4060178249A69607E87FB1EEFDBFF387E4B7BD9FC8ADC1663967C72AC2EF7A211CCC11EF95BCF70BD760260E4E60E9F1DDE82259106D52DA61E257F25CF7BED1FE911C8A9F81296D903DDD1FCB3D9D27B03E9EAA7C264DE792BAB97277688E';
wwv_flow_api.g_varchar2_table(51) := '3CDD7F466E86800C2E4E98441017469AE4CF229B95D1A5E6D11727B134628900DC4E045BCFC28FFEA2FB181C31B257CAA20CEEAD0F42C87635D054B625C8D74D5926D7B5BF2FEF238DB914FEB91B635592066B34D1839991CB114582E0F6723D0B4D5B8F';
wwv_flow_api.g_varchar2_table(52) := 'B5EF54A606A11964DE2568EB692C9BAE0FCF93BBC373E5AAE04CF91C26940907FC671265A6A7051BE4B63A045BC82A397E73E8C8D444AE51C358067129C4DC360BC7E05A9799A7DDC75F547E743D9751288EF6D2F23A824B7F7BB0FD1339020163DA92D7';
wwv_flow_api.g_varchar2_table(53) := 'F12FE964D5D4C5F277B36F930B98431FC065264EF974D54BF9BF346A70FE9321938260F03BC83BDF0813BC1C6693512C724E4A8BA3FE90FCE5BCCD8A61D40A328EA038112F8F536A89B2BA6191C8F95AE949679AB229A11E3328EA8110102EFAD37E0466';
wwv_flow_api.g_varchar2_table(54) := '5DF15E39D6D3264F9D7F571EEBFD5456FA22C84A017CA5BD699793DE5040FA127DF2E4B9B765098240265B98E10AE16ED44D3357CBAEDE53F2FD73AFCAF5F0ED5C19739CC29C5636F5C51D6B0438FFE990F16C1503B36F8ACC9766E49D995162D065A508';
wwv_flow_api.g_varchar2_table(55) := '5E10A635A266E8328CACE3DA935B02CDF6F323B3E4DEDA79B2BBF784CC224099E2309A26F5A38E13D27A6AAF639AD1AE0D96E13DAC590F252E01890072C6F52AADA8D216594192D30B6F22D4C8BF77BC255F39B35CBEDE7C03840D193608553D9674BF3F';
wwv_flow_api.g_varchar2_table(56) := '67A31C06C88FF57C2A1B038D4872C0CA28EA32C494654723C08E29CB7516ACCDBC733BB50EB960064B758C68911F66A19FA4F974EEBD0EF44DA6393E300940905786B6D1ACDF80D4E5A3F09F3EF4E516D50A6052FBB986FEC9C5D7006610E3319B65C842';
wwv_flow_api.g_varchar2_table(57) := '68DF7AFF14759D372E587FA0357B718496633A4B337834B4FFE733AF22D37699AC9EB2582CC4090CBA289CDF997B9B1CF8E437F219325DCD587E75C36C973BD9A1116097ADB96DA915BC197E0481CBD6D02C598688960101A36ADEC939D57F513E84D6D1';
wwv_flow_api.g_varchar2_table(58) := '5C329F4CE693DD5CEE84113DAF68643224A8821DDEE9B9B26EBEAC0C34C8412C8154D6CA25036328E060DA17D43441C303B8B9E057C908DEBBE59D9E142A3850BA8DDC2D5B0E14E55B1148BD8131F6B4BD2A736AA7C9B49A7A001C13FC2F2B95F6FC61EF';
wwv_flow_api.g_varchar2_table(59) := 'CDF2ED2F9E9559760051BD4FDD262CFCD19D81B10BDDD308F0F02C1A89304AB68A5421E51BA30BB1F499A6822BC50C80F2CEA58FE50F3F7B1CDA1606F7D37E915BE4A50559AC034BFF54564E598436FCB783B8F5070DBA0366FEE08593C3263D28389FC1';
wwv_flow_api.g_varchar2_table(60) := '6C064010ACBFB35E4DC39A3BE5041CB717FD75F28F9D8765F5E979F207CD374150FD6AB91582C06D6ABA467ED0734A1EBAF4966C0860390721E20A3FF73146E25861E7A934E35E949642BAF93484E03198D5F50B250CD34A7F46D3DC95E89523486A30C6';
wwv_flow_api.g_varchar2_table(61) := 'BE114B9F55464856238F7C0DC05EC3A5107CF6D1AECF959FA6A96500C584C5D5750BD146DD0C54A0137846BA34AF2A30C3550A10993DB67F24304E3BB5553DA221FA6320360FE6FD1FCEBE26871059071055334FCDA0AB211091ED736F94DBF124CA3EA4';
wwv_flow_api.g_varchar2_table(62) := '4299A12B67D108F0607336DAA4C85CFE1DC38D853F8F2C909530B70C584200B9169133EFA9EEEFFD1CA087C156242CC13C9A5D6A4218E69530BDD3F5A9F4C234D621C0A15044B196BDAA71895C8E844307CE33200AA23F9A6FE68B997D6221E84E71B7E9';
wwv_flow_api.g_varchar2_table(63) := '43EF867E1B7F7415AA3DB6A4CD595ED96A59B700A6FA7D00F8384CF519DC0C61FCC031293C57362E901FE14ED5D5786881091CC61AA38CE61D59FB7E594C34CD33334F04AA39345DBAC184EE9ED34ACB6A120179AFFD98FC16D9AB55606A0F821F02EB6A';
wwv_flow_api.g_varchar2_table(64) := '9189FF3837077EF48DBE3655AF05C10E1322642EFDE98650931C8E5F503E9CDACD4776188D9F89774A58C1E6F8E4918C26C7A14BE88375F90271400C113B1325149273093C84C71426E8615076154CF5CFBB3E94154890DCDEB416D2832735A9E110A619';
wwv_flow_api.g_varchar2_table(65) := 'F0CF77D62F939D17DF91E9E9446A3940D60870EEE4538B08EF0A44B3AF751D93231F9F42448C604AC9BFC86930723940546B5FD475FD17B59E8FA3CE80467500B89F7EFE3C6E18D466DAB2DE29B4A5A9FFD9F1679D07E6D09EDAD881C87609FAA429651F';
wwv_flow_api.g_varchar2_table(66) := '6E9F6892293CC7C76849D7C7B10BF2F0A74FA9753A41276D1792BD72A5B22A58DAA10FDEE0B80275FFE5DC7E79A1E343351EC591C15B2D68EC427CC0BE186B702EE5281A01CE9D7C8A02A7CBCCD3D17807829F73E933ECC39685D0DC290083ABDD6CB6B8';
wwv_flow_api.g_varchar2_table(67) := '621444DB83F14B722AD3D6B9B20C0CE52335FFDD7F5A3D21E98C644B1334AF09FDB296DB0747CB2EBC46BA7AA0B54FF53982E7F6D10C9AA603383768227D7CD08F8FD83E098BE2F4EC529C527E9A4F6AB2FE686366D3906FEDA1ED07CE94056077784E9C';
wwv_flow_api.g_varchar2_table(68) := 'CF2637716DCA022E50D029F17CCCCE65957371F037DB5E063017A0012D02B59B5B3EF64A66AE4250667AAEB14FE7D98BC1FD0C77C4BEB9845B0BEB408D67E177365D3C479019485D8747679DC2D19D36318C99FDEC76BAD2181BA7FD189572BA5C568039';
wwv_flow_api.g_varchar2_table(69) := '0D3280CF40674A5AD4739922CD642C5DDF6DEFB6EBA7DE8C70CDAD3BD2967DB029EF1F7BFBE079B77FB72D8F293809EF1CD21787ABEFB61BAFAD4680B3A79EFB140A6D395ABBD1AEE54A59AE7DE45A2FD77175D62BCB3249E70426665F59A6A788496A04';
wwv_flow_api.g_varchar2_table(70) := 'B892E5B8080E95A5A93E5E6A04B82C9C981C740C0E6804589F591983E6C9CB79704023C0FACC4A1EF44FD0AAFA944523C0FA889AA0A8E5312D7DCA521CC0AD87D394F03742C6E899893CA6F7A5AE4A8E22D5C9148A2A191E3B87F97E1707F0B62B95DADA';
wwv_flow_api.g_varchar2_table(71) := '067E2C64E32EC0A412E7CBFFA1F5C943806C5BFC27C528691EABFD02BE8A4B74A4A5CBB0F1AC83E143A690D4395F05D032D9847933C53EC3364C3E6782524E0DDE26DB140DA63FF009763E34EBF9F485CAAD23C7674C7E72E201F9455E610BDE291EDAF2';
wwv_flow_api.g_varchar2_table(72) := '519AA7E0B0C363C5E802BED23EB480966C42B36CC0F7A2AC7AE9BE6F1829E3DFCC7AFCB49E4525E9D3F6469DA8B4AF0AA34D692E72F35DFD1D3EC3FECEBBB73E8CDFBAA278785C08078B03388B80D52FDEB71E774EB702F346189BE16FBA1642E5446FE3';
wwv_flow_api.g_varchar2_table(73) := 'C89A0F58B68B917CFAFDDB7E7A404DB94870F5B16D327ED6C74BB7274D3CFD7F31219B1D2979A2980000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72341360387797135)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/apk.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000018D7494441547801ED5D096C5CC779FEDFBEBD48EE92147553F769DD962CC932E3A3965AEB7052A30D42A10DDC16492FA4418120685D342862C68E6D';
wwv_flow_api.g_varchar2_table(7) := 'C4299AA2405A374D81228E8E8A69D2C46EEAC68D6CABB664C5924FC9B163CBBA651D144589CB3DB8C7EBF7CDDB473E1EA2C8DD59EE5B8A43ECBE6B66DECCFFFDDF3FFFFCF3F6514447B2C4D0514D59EB6869F1C958E8473F21FAFB1D8FFCD0B20C310C8B';
wwv_flow_api.g_varchar2_table(8) := '056FFDF943B75BE27B0087F51056CECBB0A3C5B9AC21E12AC36C9B14ACFE979FDEF937279B97ED315BADED6CB7EACFC885E1BD12C531CF05EEAA171EFA8C9133BE6BD686EB54378DE2AA1E9EA8884361F7312C4BB2285D23A64433BEE744CC2F3CD7F4D7';
wwv_flow_api.g_varchar2_table(9) := '27EE7DA1C5FFE2BD2DD9B1027261D2C94BBF790F347EFBF6ECDA7D5F999EC9649FF7D7572FCF7474A571D9670BBE7000F2B7C86F06AB67B0737D4BD9474E3E678BB30017ED337262E56AFC814443241ACD65720724677C76AC810C200A4FADD2AA0A6733';
wwv_flow_api.g_varchar2_table(10) := 'E9F9D8B9257B2D01E1115C7E2CD796FBC57C9CFADC750C76CE7DDDD977F2395B9C37B08F8105ED5443542E9D8D056BAB9AC497DBB1F9E0A3F35EDCD892B9F7C516732C8CC904A1F0D4BC9C5410CBF061D45263318E689B2BE1938718B6998DEEBE96B0FC';
wwv_flow_api.g_varchar2_table(11) := '35E14FF82CDF9802B938805B8F2A136F5839F89F705B8A32F85495D14F79C30D0FDA32329DC96C201A6EF2896FC7B6438F2E20939B654F457BD7C5019C67B06DE9C060C5E7D10749C31D951122A7D30439126EB2D2BE5DF7BDFAE8A256637BB692412E0E';
wwv_flow_api.g_varchar2_table(12) := 'E03E92AD40FA3AEDA7EDA172DAFE8391BE06906BABD69B866FC796FD4F2CAC649035025CB9F455F0423FF336483960E96B892CC6E4F58699DB59C9206B04B8F219ECEA810239134B2A907D3E6BF7D6D7BE714B25325923C015C860A7C934D064B063B2ED';
wwv_flow_api.g_varchar2_table(13) := '2D6563106433125A6B6533BB37EF7F7C492FC8E07B05248D0057447FFB42E23439EFFF3B87AE4C3D20C3F15A6DFAAC5D9B0FE5416E6D559EB72BAF27773502ECC9FE0DDD2887B243FBFF3D209B04396BEDFAE4816F2C6504AFB90240D608B023ADA165EA';
wwv_flow_api.g_varchar2_table(14) := 'A9AB6ECAA2F943F4A017E49AF0EA8C64F66C7EEDB1159500B246803D05DDF01AE3461460BBF11EA4021B643B18B2C2CCC9AECDAF38206FF7ACB9D608F00DC43388C4CA7ECADDE4A119EC34D5F6AE01B259135E61F800B262722BCCB53741D608B09B0E8E';
wwv_flow_api.g_varchar2_table(15) := '3C2A687B63063B9D412413DEB58BC95B0E3E726BEBF6D66C8B7CCD103E38E0A1A4B1316E3A78A887C3698A13C91A4E5EE641C40B93241FA65019C5E49CB97BDBFE47D6B4182DB9E66588CF7B08648D00573083079F070F09779EF02641F647C34B2CC3DC';
wwv_flow_api.g_varchar2_table(16) := 'B96DFF136BC8642F81AC11E00A66701ECA027AC0222E9011D63CF0D86DCA5C3F8C2B1E60B246802B90C1EE2663DF7D38247D9D8B76813E2063257CD7D6579E584F73DDF270F941D608B0D3EB0ADABA298B7DF7E1B07AC1026E903B931944BC16E3C9909D';
wwv_flow_api.g_varchar2_table(17) := '5E015923C02316CFB064382A9946EA64B91BD5DB6D3E0464623D9963F242AC42EDD8FACA236567B24680476CE0DC622AEF7EDEC9D2D0080532A6501984351719A6B963CB6B5FBFBD9CE65A23C0BDAAAC4150A35B45310C1ED8D25E906B0072D6D8BDF5E0';
wwv_flow_api.g_varchar2_table(18) := 'E34DE5025923C015C860A7C9FA18ECC06D83DC05735D139E87E7BD76960B648D005720839D26E7970B1D74346D59BB99B1419EEB0659D53F4A53288D006B12CB6856E366B0B3AFF7FE2E90430479D796838FDF8DF9716EB440D608706924A457DEFD6A73';
wwv_flow_api.g_varchar2_table(19) := '189C3F5DA21EE4414ED15CCFC168B063F32B5FBF67B440D608703FE155C2A11B51C0D00F6F9D3DC8838C31B93A34CB671ADFEF61F2C30F5B2D56E9162834025C42F1E814B5BB2E779301B61B6F77364DFB36C8313239340B3F7EDB71FF2FC064FC60A045';
wwv_flow_api.g_varchar2_table(20) := '4A07B246804B2C1E4D52BE6E3510BF1BEFEBE62BEE82ED5DE741CEE58C9DDB0E3EBAC906193C2E019335025C5CCFCB52DAAD93A567B0D3C5FC142A95C6983CC3B2CCA7B71D7C02200B98AC1FE49B1B6087B29C268D0E837B4116C39FEE4A02E460A36559';
wwv_flow_api.g_varchar2_table(21) := '4F6FDDFFD8AF9702648D003BD272FA5001DB3C83D52F1AFA3398D746F261776F945FEC3721D883BDC59F6002643239D8283EE37B9B5F7DEC3E05321F1CD8D3CC5F3D169D3402CCDE556652E4E5973BE0417D1DC9875DBF517EFE38C6C9A776D4EF6C0319';
wwv_flow_api.g_varchar2_table(22) := '8EC99150A3CF921D5B7EF1C4565EE29AB28EF5648D00DB2DAEB46F800A2AF97206F8649878098581A77186F3C1EF598695EF4675B11E9F6166E3A96EFC7475B26959FF76FFE12715C86AAEEC56BA02845BFC4B587A6E6A2B67CFA1D7776070086AC6CA99';
wwv_flow_api.g_varchar2_table(23) := 'B1AEAE24CC66ACEC4DEE8CC77C7EDFD46C3AFB776B7FFA971F1CBEFF9BC79A5B9B7D7893025F275250D20870859968E82355B2DBCA86BAD369531219BC7727071AE3EC605D6166E7BC7BDF11BBFB9C7B9FD7DDC7EE7DA76C3E0FAA0FC099CEC2322CF5F9';
wwv_flow_api.g_varchar2_table(24) := '8C99387DAC55FD06DB7E55863BFB70F73502CC9657588244C1624382FE80023691018838893752F4A2C93EF53F769F73AE395BF7B5FEFB3C6672F2F6DDD20533FC7EB132D98C95B6D098E2934680D1BA4A4B8E7C896A80EE081C570532D602C8E49E3458';
wwv_flow_api.g_varchar2_table(25) := 'DF9C73FDB72CE49CEBBFEF54E85CEFBBC51DF1E21FCBC4D6B05F0F83FCF9D764382547BAD5E864B90532D2669431BFDD6C5846083500D9866125C9EA9C9A3CD9E7796D143E805BB5C6815D49A5E7351985C94823C08535C053A5285932391CB0CDB47A9F';
wwv_flow_api.g_varchar2_table(26) := '96A75A38E2C66804B88FDE8DB8219E2A308640D608B0A7202ABE316304648D0057E8183C942A04219E2AC75C0F95D1BBD734023C864CB4839733262B9071B2D463720944A81160472A636CDB076458A91280D023B11218C171807BA43BC4CE00904B8472';
wwv_flow_api.g_varchar2_table(27) := '09AAD5087009D46F08998FFA250ADF0F71552136C4485729CC750944A811E012A8DFA8A3388C1BD2BBEE71BC34F7597375EC8D468087219CB1908520940A646F33B804ADF3AA42F401191C2985B9D6D4778D0C2E817DD1D4C99254D303B2C631B90422D4';
wwv_flow_api.g_varchar2_table(28) := '087049C4E8ED4A7B407682212540A848098C035CA400D5BCB8674C2ED25C976094D30870095A57ACF047AB7C0F93359A6B4D6DD708B0A616556A353D20D35C17C9648D32180758A3307BCDB57798AC1160EF39183AB11B765D0E93ABBDE1786904F8261E';
wwv_flow_api.g_varchar2_table(29) := '83FBA34F9019D61C29C825E08846804BD0BAFE82ABA4E342402E014734025C82D65512A083B5D50DB209519781031A011EAC87E3E714A86A150A63321F881D2AAC590205D00870095A3756F4433119E072154A31F93AB22A8111D40870095A375600663F';
wwv_flow_api.g_varchar2_table(30) := '860BB2E63E6B04F83A5AA9B9C1155D1D5F9E44337D23266BECA44680C7197C435C1C11F9AF03720938A211E01B766F3C832301327930901D0570F269D88E03AC418823AE82408ED298AC11E012D897114BAEC20A0C00597FFB35025C02FBA2BFBFDEABB1';
wwv_flow_api.g_varchar2_table(31) := '0FC890A1669E68045873CBBC0745E95AE4069963F350C19011B602EB5ABAD238838B92A43385C2CB06248383B41EC26804B8A8EE8D17263F7A980C58C27A44320EB01E39EAAB8520339CA9E991758D63B0BE3E8ED7A4C73C538E15C560BCA1648093A9FE';
wwv_flow_api.g_varchar2_table(32) := '1DE80834827530F1E5946EAF8143206D24CFB9AF30B75386396E9446DA9EC1EB73B76CF01CC33DAB11607D5AD7BFF1ACD90FB1470D3F0C17DF8742206C2124ACACA400C18D4442904CE4AA411D786792028DA0E245A0EA9D2BBCC63ABA912F893A9978DF';
wwv_flow_api.g_varchar2_table(33) := '10EE586538AF8DE419F79D9C637BCB76C551368DAD3B17EB2A57D2087069BA44D151F814FAEBD94E489DB0F05EBC2232CB5725537CC12185CA9C0496601ECDC6A533975265ED2F1B1C7BDF9069BE103E412880AD54A790F7422E91CFDF7BDFFC897EE70D';
wwv_flow_api.g_varchar2_table(34) := '996F5649BD11908C4740D60870DF2EEB3AA29380D70D4AB5CF2FBF8FFF6B51E50B4816C73EF5A6234B8EA53BE45C3621D5F86FCDB6991D78E76AB0F01D00DB05B0EE094E9655E1293229582B51330CCBE083F264E45A262117BBAFCA91549B5C42BE5AB0';
wwv_flow_api.g_varchar2_table(35) := 'B60B4AB53650273303B3943A29B653B91C9CF35B3297ED613B8FA7AFCA79B42784F6D82A38B03DA379C6D300537E349107B3D7E4AB75EBE4F7666D92B01990742E8B5537FC9F667C5EBE74447EF7CC4F64AD590381F2AF6F62F957B331D91C9A249F9DB8';
wwv_flow_api.g_varchar2_table(36) := '5E56D6CD9349E13A0942514C9F6D987300260390B3A8F758ECBCFCEBB917645FFCAC9CB252F2A5094DF2C9C63B14FB998FAFD0EA73131CE6601902B0107128C6F74EEF95C7DA0FCB067FAD24AFAB727DDB58CA238F030C5650481062D384253227324DB1';
wwv_flow_api.g_varchar2_table(37) := '57091A52099A41593361A16CBA3851DE049317C25C53A8540CA6B0528E987C3EB240FE6CD666595C3B1BBFFC04D301540F1BEDAC28159410400FF9C332F772837CBFEBB81A0E6AFD3532B56A22F2E7D4BD0930CBBA138F03B0305DD9A4D498215CCA2A46';
wwv_flow_api.g_varchar2_table(38) := 'F75104778151DCF7F43489CED01B10DA6F8767CA8248A3A4B2DDD2954E4877362DF14C4AED37846A6573ED626987590C905DF91404B8C77349B92F3849BE387B8BAC9C305F01C672991C95C6E08B4825994B2B25A21346D8C862755DA909F2E07A2293C4';
wwv_flow_api.g_varchar2_table(39) := '27A53E496CC958E6EDFBC1BB4CF3E7F24DF0C4C6D30C3601420E206DAA5BACCC2A2546D34C60B865AA06E3D6D402BCB603CA83A5D1B53D66918B708E9A276E9445D19992CA7403AC8C8460E2AFA6E372A8FD7D39D9751EACCC4A184E551D146555ED5C89';
wwv_flow_api.g_varchar2_table(40) := '86226023BC66309689C300EFC53AC95E8EB3EF5D3B2531D44113AF4006E07E8CD9895CB77C9CEA80F204918F57CA9F3402ACB743042A06F688592DB7D6CD5763660EEC4A0390F76267E4969A46BC5A929326917991E9F23B55336577E28CDCE18F4A0A20';
wwv_flow_api.g_varchar2_table(41) := 'C4904F7C61591A9DA5004AA1AEA0E99704ACC09E33FBE4CB17F6A2244BE7DB0D1037C301BB23324F4EA42ECB1278C3EFD16BCF27729640C760519E3EB74FFEA1E31D591D884A22AF08CCC6DA82F8BE1565BB159FF385CBB8D10870AF792CB63F1439BDD0';
wwv_flow_api.g_varchar2_table(42) := 'D7339DF2A7D15B644ECD54E06033280E73F972DB5199196A901AB097267522D87757ED42D9DD750C53AA288CB3E0EDDE595982E94A2D846DCF70E1E9E28F2C3E103B01CFA85B36851A15106425E7AF3FEB6E979FB5B7C9528CE50D60356838B02B38C531';
wwv_flow_api.g_varchar2_table(43) := '1CEFFC55CE9E0212E7D4CBFAB1A51204F019A4E4C0BA46E18C4680F5B556A98A327119B9B36E91D40523CAC1F1C3249E4FB6CB773ADE927B1A964A63F524353E86E16CADAC9D27814B1169077051384B61CB276700425736056133F040F39A9568A04ABE';
wwv_flow_api.g_varchar2_table(44) := 'D0B851CE9EEA94BDA94B321B604E06981194B90B1FCEB719A8E0388B22031287F930F255C33A4CC29CD9CD54824AEB9155F71B50B42C27EC81AC2CB71EFCA61452004CFB18538E95810659563B078C30156B380E7ED079564E26CFC9FB9D6714604E2DB3';
wwv_flow_api.g_varchar2_table(45) := '6BA6C8E7ABE7C82F31DFA583C5796C0C63F047F1F30A2C8EA59C3FF3A5DBEB26DE22FFB4E841F9D6D44D320F66F6304CF1E14C0CF3DE8C5204DBF0A36636A65F22EEEDB8473C73595ECA5C9503F0DEEDCF150462BAECB1BA5F99721E6A64F020D228A867';
wwv_flow_api.g_varchar2_table(46) := '968401C6895C5CBE52B75CB194D31002148307FD46E70930CB94376227656B774C6A0335F07A333201818B0D30D3FFDCF9AE0252D10FCECE7FB5BF25B7372C112A400EEBAC1CC34D28C0C2E80C9C9B2ABF115F23AFC1E1FA51FB9BF20C146709185D0BD3';
wwv_flow_api.g_varchar2_table(47) := 'DEBF3724334D7310D3A14F4F5E277747172ABF80D6C19926BD1F3F27BB3A8E08FEB1068618D313D12C8D000F62CF0A0098EC49010401A0EBEB164AD45F0DA66694303F8E5D967792E765B2BF5E8E242FCAD9789B4C9C502771005F1508CBB2E86C5901D6';
wwv_flow_api.g_varchar2_table(48) := '9F81599E8EF9E87A3868BBE2A76421820F9F9B739F4CC77C96CA90C1B89D84B3E5C73DE6C3419B5B334D9A262E938D175E93AFB5BD8AFBA5A511E6D79D68E2690108F0DD9357F65500001AF407E515045D9E82F31541BE6A043E18AE2C77D268A28BEF0C';
wwv_flow_api.g_varchar2_table(49) := 'D91086E61FC29C765B683AA6373394D34286705C7BBBE323793E795A2E41015E4A9E95373B8E294747BDA01D73DB193593656BCD5C390DF6D34C73F45D6746E4D12B87E5C90F7F28872EBF0F60E94D23A0810FC75902CDA9121DB9CFCDDD224FCDD826F4';
wwv_flow_api.g_varchar2_table(50) := '9D6350042A9963A7D93BA787544286389D0F1D2BEEF3BC3DB97260754A38C7A3BFD5C8E0E21B4F7170D5C8C2D8B91126706AB841099FE699818653A976D9106E943900ED04C6CCB3DD1DD2851832BD6932B30EE67A1DE7C457DF52CE12E1A1C3B41EF99F';
wwv_flow_api.g_varchar2_table(51) := '8A7D20FFF1E129F9F3FA5572F7C4E5CA444F80F346E561E83301D6D359DB327DBDFC55EA8A7CF9E2CBF90E71F5CA4E8E8D4AE35ECE395E611D0C9CA8102A8E9D7C76A9F27E7B06600A8CACEB8017CCB9EF6ACC7DABFDF052C1383294ECD83EE34EF974AE';
wwv_flow_api.g_varchar2_table(52) := '498501C93E136147B28702A6031682F95C8C79EFA6E014F9BFEE2BB20E61C674FE1A418EC1F47EF5F27E1130FA8B9145F2A9C96B656DC362A986392768643395E52E28C0AF5D39222F254EA07E072EDB0F6030E3F9F387E54CFC820A90A831186D67A0E3';
wwv_flow_api.g_varchar2_table(53) := '38162AEAD14EFC9FABFCF8EB942D1FC81A012EAE33B679F6C39BED943F88CC57C10B8E7B3C4F4E708A34BB7A0AF66C46F16EBC9246002397378C9C1373EA744F64AEECBD7C1E4A5123EFC21A2C86B3C5A90D6254D284313A0E30BF7DEDA87CBBF3A87C27';
wwv_flow_api.g_varchar2_table(54) := 'B14D7E0B8A5305F6322C49C56980C3B62038415E8AFF4ADD8FF0F05E049B2C7DAEE35DD9D10E45415D4EC40B2E18022B504C28270A7966AAA411608AA0F0A4808370299A2698E749A1BA9E691005EB87D342962A41F6DC06FF2805C0717ECB7154CD73FD';
wwv_flow_api.g_varchar2_table(55) := '55B29A661A2B3A9C936E094D951FA52E401362B206512EAC21A979F203FEE9F26C779BFCC9F9BDB2A67E81ACAC9F8F58372267B8072D06170F98FAF78A846EF447646A68862C37A31802EC5651E138274EE29E4C3CF642D20870E1DDA110AB606ACF200C';
wwv_flow_api.g_varchar2_table(56) := 'B834502F2B30F7E5B220C75D0AFA6ABA4B8E741C57E69AA690ACA6421050327B59DD5CA5105C8CA0F344E7EC5300F6D9D4797964CE03F220CEEFB870407E08C78C11281B36C49BC1EE3FAE5B8DB13BA2A640EC01EBA52588634CB68FD5A6CF571A205E00';
wwv_flow_api.g_varchar2_table(57) := 'DBE7F832EA69124709BC02AABBB11A012EBC7B048CC18D5310F897A28BD4FC94A6921F3F00667063EBF19D000442C73C5581044633DC4846FF64DE8372DFF475827F2DA9A640D3E09CDD159D2FCFC68F8169F5B2B47E9E0A98FC61EC9C9C4C5C922B992E';
wwv_flow_api.g_varchar2_table(58) := '35A6CF40B873ED844532ADAA418530D903FC5B39B998BC22EF765F56B16C9B9F6E91E5F749651600BA85F77C907A359FD20870612DA3F6738AE13C07755B749E0A4DD2B9A203C571F1979DA780239EAEF04F50DC55112908388C31EFD5CC15398AEB9F98';
wwv_flow_api.g_varchar2_table(59) := 'BC4245BC686639275E199D8315A66A449C92B88325B3AA27CB4C4CA3582F994F58C876CE85D359AE3A5B528330E61598F2E7DBDE842FD0A59489F7A2023A8E9CF29871AC527E631F78F39B33094DA9B0DE527834CF8710FEBB1F5320322A024F96E04603';
wwv_flow_api.g_varchar2_table(60) := 'D5720DCB726FC400308E193CE05D788D290873CDA5B9C3F1D3D29EBA261100C440041DAA1560ED83D5F314709CF732111C5E8B629C8EF21E003987F93381E6B2631BEAF8C1E97DF2F895B764039D2594669894CB892138611C3642D857F7475D5E66AEEA';
wwv_flow_api.g_varchar2_table(61) := '30BE3432B8B0EE72CCB3DD929C2C0A4F528ECA89AE0B6ACA42A1BF7BF5841C46F46A3AC287DD6013B9660714EC27181741E007313D79BDE343F1038014C64E3385D83554614178B23C73F1900A734E851966583348D3CE84E6B2C50C7C74246272026BC3';
wwv_flow_api.g_varchar2_table(62) := 'FF03E6FE7DE77BB21C4A632B914F2E83C9A760D619A66428A313419818C674864BFB063554AD9EFBD20870610CA690F9E8EB328CAD471317E49B1FFD187EB42D3A0AF412049C8279E693937C1C87E032714B0FB606820E40F8FF787E9FFC67DBEBEA1AC1';
wwv_flow_api.g_varchar2_table(63) := 'E5925D7B262EFF0DF0FFBDF34369C23359F331F5A9C7DCD8F19039F76D47C0E47DACFF3E8395A51CE6C9AB60F68328CBF5E465983BFFF8CADBB2BFF323653978672E2D9E495F9315584DE2FDBD9E34025C5C57B9FE7B12C2FE5F3A372A519C963482B953';
wwv_flow_api.g_varchar2_table(64) := '6056AFA73E3CCFB2A751761FD6736D5EB2024BE642296EC37A701BC6F13D0978D0F193BC802CB692C066F340B19196A001A03146C5E90E2D0B170C3E42BD3FEFA9D7CEBF0C716A2AC1F5DAA4EE51D497BE9A3D0330DD9E0804BA01734CB29363B33D15B2';
wwv_flow_api.g_varchar2_table(65) := '053E94BCC8A389508469887C3998313F4D3AD93C1D8FC7CEC0711617ED3F5EB55581F7E223AFBC460B6143682B00E3DF0DA8772AEA7512CB737ECD7BE6D5C4B9A471ABAF66CF00CC2E5168EE47601C890DA7BBFC45029FD552294F00A75C3CBFCECB63FB';
wwv_flow_api.g_varchar2_table(66) := '635F71E0564A81F25428A70CEBE13E19CD254677B2EB709FF1EEBE4680DDA229BCC385D632543967DC66AB883D817527BBECF56BB8FE15772DDEDC2FFB34C99B622977ABFA2A6031ADD1087025EB7931222C45597DB2D40870293A3A5E67B112D008B03E';
wwv_flow_api.g_varchar2_table(67) := 'B3526CA7C6CBF74A4023C0FACC4A6FF36ED63D7D64D108B0BE46DDACB0F6F65B1F598A03B8F568BE255C63C513C7FADAD5DBD79B6D8F32541373CA14A947C6F6E148BF8B03B879B9A2AD65E01FEA5AF8F1C63889472AFF81F92943806C65F94F8A91F232';
wwv_flow_api.g_varchar2_table(68) := '56FB057C1517E8C86B97616169DEF0217EC0D6D95F05B465BC888AC128842DC3CCD9742927839BA5598162FA035C6EF995598BA72DECD53F441D8DF1CFB064C0082D65852D64A764485952A6488E8C95A00BF82A6ED4A45936F86B1F91552F3CF4193C32';
wwv_flow_api.g_varchar2_table(69) := 'F35DB316EF4760522B364A1BD5A1F7BE3CD6363B202ED9CEE4559F61FDD11B1B9FFC8192994BC685C8B038807947570356EDFD8B0D62F97F1398D783D1BDEF5228A4653753195BD77C106587189967DEDEF4B70755F75DB22DAF38C6FD67FDF2D724D3FF';
wwv_flow_api.g_varchar2_table(70) := '07664C396839AAA2220000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72341699031797136)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/asf.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D0000164D494441547801ED9D6B6C1CD775C7CFEC83BBCBB7484A942892E24BA4244A7E5556A3182D90B4055C14753FB4528BC4683E240DFA21B1AD5856E4';
wwv_flow_api.g_varchar2_table(7) := 'C24058A90FA0ADF3A528FA48D2A68D25595682A0285A04699BA64691C4A95D3BB668499648897AD892F810DFDCD7ECF6FFBFB3B31CAD4891CBBDCB9DA1380239B3B3F7797EF79C7BEEB9C391889EC3D0534CE94AE9EBEBF3A176CFF72357820577280DA1';
wwv_flow_api.g_varchar2_table(8) := 'A0109C448E7CF653FB7C86FFA9B4A46AF131254299B9F448A7D1BE74D81F2C1B29AF28FFDA4B2FFFD5D06B070EF80F9E3983FB567F5CDAF2BC9A55106027DCA3BFF7F46FA6D3E96F8443A11AB6C0580565E0A85A6907D48804635FB04C8C50F87BBE60E0';
wwv_flow_api.g_varchar2_table(9) := 'F75FFAE39787A0C901FC98285A25C1D9D3C74AE5A33A9D19F1E61F7CFEE92D662AFDEFE5E148EF4C349AC0973E165C0800A754172A67A17BCE3CF6B59DCE3EF37EE6DA8012A70265E1B98ADADAAA9469FEC830039F7AE9E5B505B9201B7A262345332DED';
wwv_flow_api.g_varchar2_table(10) := 'B8EC998BC578C70709FAA0CD9933AF0BFBB1CABBBB8C85EE2D548F9DCE3E338DB06D4AF98D001B6CA6CCE94824FC71D39F3C79FCF017DAA1C149FCF8AD344CE1DDA320C0BDBDBD540648C8E74B632AA65986E6AA0BFCCA9CEDCF6E3AD36DC85A773FE01B';
wwv_flow_api.g_varchar2_table(11) := '7373D1742414FA78DAE73F71FCF0E13503B920C0FDFDFD1494A40C338D0B88899F3C7960808A118D46CD7038B43FED4B9CE83B7AA8632D687241806D0DA69DA3803C89968D36244D73431B138BC64C388AFB8D9479EA4F8F1EEA22E4D75E3B9031E9DEEB';
wwv_flow_api.g_varchar2_table(12) := '6141809DDDF52E5DF462DEF66434396646C2E17D8974EA2434B9EBE0C133A657E7646D80ADC9D889DC43D7D060D55A788638FBA0D146740E9A5C167ADC9781EC554DD606786D6870B61716E49805D948A54EF5BDF8A56E6A3296869E32D7DA00AF090DCE';
wwv_flow_api.g_varchar2_table(13) := '2872C6F6289051408677BDD730CDD37D2F7E6107225DA697E6646D80B363DF439639DBD4EC1C7C4F2F9C901FF19B7E68322067341983FA9E0CD9325D72A10DB04BFAB3B266D873F0DD1A6C9795851C0A8514E43F79F179A5C96760AEDD0E591B604F9B68';
wwv_flow_api.g_varchar2_table(14) := '1BE5E267053906731D0A953D629AC9D37D879FD94D737D9090D30C03B8F3D006D89DDDCBB755F7E5642DA16271400E3DE4F719A708F90C211F3CE85AC8DA00DF5734F9CAB964E997B4434A93A3088600F26EC30390B5015E52342583964FC5CB1AA6D612';
wwv_flow_api.g_varchar2_table(15) := '0A614D78D7BB11FC3A75ECCB87F6D89A8CF5B23699E6D3F2C5D26A6BCCB244B3582B4A7D3FEB452F7B9802B2616009958C8443BB259D3A7DEC4B5F7C9490199F7713646D80972D9A52C35CA8FEAC17BDD0978BDEE3B6A39F9011BBDE99F61B278F1D751F';
wwv_flow_api.g_varchar2_table(16) := '646D803DADC1598679F6823B1419C8885DEF489BF39059A41B34591B604F6B7016F00A7A91035952BE537D470EED055C3EDB5572C8DA006765E4E98B3C35D8EEAB0332CC758F21A953C79E7FF6713740D6067885A2B14554DA73D6C92AA0190EC8F0AEBB';
wwv_flow_api.g_varchar2_table(17) := 'C42F27DC00591BE01518B702A4A939EBCA9CAC7B1BE1800C4DDEAE201F2DAD266B03FCC06BB08DDB011961CDED7832F7D563879FDB5F2A73AD0DF0DAD0604DBDC8408EC5E2C948A8AC23ED4B9F2C15646D80D786066BEC455693E3582797B5E1A1DF93C7';
wwv_flow_api.g_varchar2_table(18) := '5E5C7D4DD606D8B6509E3C67E7604D1A6C0BC1A1C930D76D6202F20BCF3DB19AE65A1B60CDA2B145E4FD732E64237DEA8FBEFCEC2FAE1664F564BFF7A5A8AB071A4DB4B34977436EC1DCFC4ADFF3CF3E0DC8AF67F6927D367067361DD7DA001749343AFA';
wwv_flow_api.g_varchar2_table(19) := '984719B44345EA89822C7E3A5E30D759C8B80DC86C625F5120AF9BE8BBF01709AE5D07FFB207B16B05B9ACACC58760C81F1E79E6138C684383F9A38D875DA5F602ED82BD795E054F22A3C9F1783C014D6E06F3578E1F7DEE939057FA2B4580BC0E982331';
wwv_flow_api.g_varchar2_table(20) := '1BAA2CB206DBA35EFD8D9E04A0C984DC944EA55F8126FF126AD7AEC9DA00AF92686C11E93D176B9994D34A02B46FE182E63A108B2AC85BC0FC9FFA0E7FF197F13D21A774996B6D80B32DB77BE0A5B3ADC1349F453C145467F9ACCF9060C6F16AF2F97C27';
wwv_flow_api.g_varchar2_table(21) := '8EBFF0CC934CA20BB236C0CE767BEA1A7A6418BE9492B561F0CCBF345CB51F9F55973F1E4FC6F1A7AB9BC4E7FB26FEAA310B19B22C68D03DD0CB24424D274D7F74663A0A259E7658D0928CD1B95999861637CE24CDAFBEF0F9CF5CFCF3BFFBC7810378EE';
wwv_flow_api.g_varchar2_table(22) := '9ACF7AADB441DA007BD544E321F6506236E14F264D2E470BD296954298CF970EA2092606DE4E3C92DB8CFB03FC1B6C009E4F92E79536C025964C9EDD9E4F0E611A01C317348286244D137E8F45D91EB0EC17AFED33733AAFF979B1C34E679F99CE796DE7';
wwv_flow_api.g_varchar2_table(23) := '9BBF6788DFE71313A30EEF8749DADF1772D606D81648218D2955DE34B0622E8470FD0A321FA6A2D079D8FDB2CFCE7B2AC17D7ED979ECF362791DDFA770ED576F33C9D46CBF26E33ED5DCF72B6D4E962D90FBD6E6DE2FD97C037F8E6204FD7EBAD20604AD';
wwv_flow_api.g_varchar2_table(24) := 'EEF1FE2AFFDC2525FB351977DDCCE38336C079D4E9EAA43EBCE10B901734A5AE6EF8228DD306D8616616A9CA3BB7D712646D80BD836F792D5D2B90B501E644B5D60E2764AFF64D1BE0B564A29D306DC8BCE7C53E6A03EC14CA5ABBB621D34A790DF23AE0';
wwv_flow_api.g_varchar2_table(25) := '658E46AF42D606782DCEC1B9ECBD08591B60AF99AE5C78CBFDEC35C8DA002F57406B219D97206B03FC209868E7E0B42153806EB65EDA00BBB9934E303AAF0939E0F2B0A636C03A05E7A5B26C4D76EB126A1DB086D1644376A3B9D606F8419B8373C78532';
wwv_flow_api.g_varchar2_table(26) := 'D701F7ED4269039CDBE107F1331F1A0802B29B34791DB0E69148C8011769B236C00FA217BDD8D8B035D90D8E9736C00FFA1C9C0BDB2D90B5015ED7E05CC4FCFFFDAC39B9949AAC0DF0BA06DF0B98776CC8DA04BD70358BDE2D55BD8B36682D7E61432E85';
wwv_flow_api.g_varchar2_table(27) := '266B03BC6EA2EF3F34F96732A558426903BC6EA2EF0F98DF66214358ABA510DA00AF56839716A3BB5328C8D8A0A0E0574366DA00AF6BF0F2075656935701B236C0CBEFDE7A4A4A60B520AF032EE178CB422EE29CAC0DF06ACC27256451B4AAB3737291E6';
wwv_flow_api.g_varchar2_table(28) := '386D808BD4BEA209D64D05DB9079567FA0ACB171DA00AF6B7061542CC8F8DF7AF018904E596A03BCAEC18501666E5B93C158DBA1ED2FFCB5B5E8012F8890F9201FFFD05FC7A14D83753466BD0C4B028C5DEBD2BC75C02E1C553AE7605D036555C584772C';
wwv_flow_api.g_varchar2_table(29) := '2F589FF24273BEC94DABA6377AAB4B1CB9F996488E573EA0CCA58B5DAA18F5BDA6625459DA002F2CF265F527CF44D895292B530E895D270582570F492A99A0A7A2CA23201FE6B24020987DDFC642E9EEA91CF98C9C7C9902B3653BF3B04CB623954C4ACA';
wwv_flow_api.g_varchar2_table(30) := 'C49B8F9631789CF98B7DAD0DB025D6623797EFEF4CC9C4F04D319371C892330C5F8294965045B584CB2BD5F794B80FAF448AE3D5717353E34803FD82E099375C5923A148B9CA734F6B0917EFA94AC4A23239720BFFA9A899A98345A087F87EFEE035CB44';
wwv_flow_api.g_varchar2_table(31) := '1E7C17AEAC96B27064E172E733ADFA9536C0ABD17202A2305B77EE81168700006FB4C2670EAEA9F13B32796744FCD0581E26B4B976D36669E9DE05A1231D7810DEE4D8884C232DB5FB9E832F21832696035653FB769546D5C18404CC426CC6998F6AE0E0';
wwv_flow_api.g_varchar2_table(32) := 'E6D4D8984C4FA25C0C2C371D9E014C387393E3D2B5E731F9B5DFFEB444CACB05AF1F547069B22F9D7F5FBEFBF77F2D18024A93C6466E4AEFBEFDF2895FFD750906CBF082B3A49421DD85B3EFC93F7FF36FC12B0480010B7E86880F16616A624C9E78F229';
wwv_flow_api.g_varchar2_table(33) := 'D9FBC42F5877A1A18944426667A6A5BAB616A5331001ADC5BF14BEE39BE95218403FF9EF1FC80FBFFBAA54D7374A0A9AEF96C31380A9252021C9784C7A1E7A549A9A5BF85109961765A190B47775CBD6CE1E1978F74D0957544AA02C2CB76F5C577370FD';
wwv_flow_api.g_varchar2_table(34) := 'A64689232F01B76FEF960DD0ECB1DB3761D283AA1CC250A61969CAAB6AA4A3BB47366DDE8C3C713C851194E15B3715B4FA8D9B2C25A645409B689EF976BC142C4939EA341371DC770B5AAB1DDE5826419809087F4363936CEBDA0ECD4DCA1CE6D70400C4';
wwv_flow_api.g_varchar2_table(35) := '623199999E8659AD94AEDE3D92C4FC89573D4A454DAD5C7EEF2D19BC784162D1398923DDECCC0CD255C9B69E5D1283465A3032A0A0CDB3B010CD5D3BA4B6BE5EA2D1A8445107210F5C3827A3B76F2BA01C28FC2EC69F39948BCFACCF9E2EDC8517BE88DB';
wwv_flow_api.g_varchar2_table(36) := '1AB4507BA8C1D1E949E9EC7D581AA84538180C48C274E2F5BBEA33B5B8B5A3536A37370B5E0F0C0DC61C0D0DBB3A704999D860D09A9B43E130D27559315F681E8A519C99D64C44A5A5B34BAAAAAA95C5A0074E7837862ECBFB6FBF296FFDF87F64666A0A';
wwv_flow_api.g_varchar2_table(37) := '261F9E3932B2CE3BA323F2C6EBFF857A2E4AA4AAD602AD5AE48E5FDA00DBBE87EE6E519034813C6FDFB547088830F8731326985A46C8D4A04D9BB7485B4F2FE6EA3B2A3D3DE681FE9FC9041C2095067938776E69698503D6046F3986E6E20E5F420A4D8C';
wwv_flow_api.g_varchar2_table(38) := '20FDD6D63609021CAD44201090F1B15105EFADFFFC57F9DEE96FC9E4C4B8E57CA12C3A6AA3C3C3F29DBFF9AA5C7AEF6DCB8B473BDC7468035CACA9874BA1D8EC8C6C6EEB92E6B636253BC2A6E373FEBD7700604C02D0287EAE84E675ECD88534D4EE3896';
wwv_flow_api.g_varchar2_table(39) := '2E55726B68406E5C1D825B84BB6AB09852BBA14E5ABB7AA0E953EA9E1F7F4B34070BD1B8AD5336629028478A83017533EFF0F521A9D8D000E7AD5CA5578DC8FC62996168AE0F8381CE171238BF2EF9B536C0C5EA0905189D9A90ED7B1E55606C6D9E9A9C';
wwv_flow_api.g_varchar2_table(40) := '909FFDE875B97DF32300814585E6F821E496F676D9D8D286F5EFA4F29EE9D10E620EE59C498D637E7AE0DBE06C99496A300ED4119F9B916698EE9ADA0D62228F1F69E398CF99378E399C6B5C6EE5A9CAAC5C99AC780D3183295C9317CB8C39EACBF7D2D5';
wwv_flow_api.g_varchar2_table(41) := '80093789F52CBDE2CE1D3B31AF9659E619BDBCF5E10DB97AF60D353FD28152F010CD6A80C7DC06272A3A33A9E44D333D78EE5D19C75CC9250D4D3BCD75134C71E5868DAA7CAE7D83A1B034B77748381251733BADC2D8C8B00C7D704ECDE7249BC2B22C17';
wwv_flow_api.g_varchar2_table(42) := '22B55645B0506E2EFC7C611423BD36C0C518BC9C1BE7A0BDAD3DBB65F356BCE15E994D681B80D2A9814AC9F5C14B7207F3A46DA6B95C69EFDEA980718E65746B0426F6FAD0952C1B42AE6FD8285B11CC48C4E009C31BAE6F6A95CD4D5B5124359173B5A8';
wwv_flow_api.g_varchar2_table(43) := '3CC337AECE47A816B3BE2E33CBCE81A20DF0627D775696EF35E5169F9D96EE3D0F4B5575B532AFD4BE6998E7AB973E90BA966E19BBF59132D359270ADF6FDDD6268DAD9D6A70103C07DF2002215CD6301DCD74455595B475EF5061C9787416B0BB64437D';
wwv_flow_api.g_varchar2_table(44) := '03B4D154F3691466F9F207E72581730081122B78B1502F17BA976F4F8B975E1B60DD1A4C4DE2DC57036FB70D410C3FD6A904C3F9726870402EBEFD63285A4A6E0EF4CBC5FEB36AADCB7993E6B67EE34665A61300C76813E3C497CF9F5526D79E87E92137';
wwv_flow_api.g_varchar2_table(45) := 'B775A89027E3DA2D1D9D2A5841EF99C10DAE7B872E9E974088732FB57A31EF5877CFF5C2D606586BB32033C67467C6C7A47337D6BE8D9BD5DCA9E66478C7A3B76FC1AB46E4AABD5B5A773D26D31377A0D59359331DC666423BA25104CB41128A54C8D8CD';
wwv_flow_api.g_varchar2_table(46) := '1B72EDCA65809A6FE9A62D5BA4AE71ABFABEA9659B72D2D4120C899876F4C36B122AAF005B861EDDADA9F3BDBAFBCA9DA14AC8524586A0355D58FB324AA5B4176D8742CA238831EF796CAFD22CFCBF7F3863A902A8DC32E42020C4ADADDB640BCCEEB50B';
wwv_flow_api.g_varchar2_table(47) := 'FDB00258FA60BE1E38D72F0FFDDCE32A40C1F2AA11EDA2E7ECC332A9A191316478E2B0027388785DA1798E47E188D5C36C2FA6BD14A655DFDD6275CF276D80B58D6FC0A1C0E7A6A7A4B16DBBB4C08CD2FB8DC374F2E01CBA1171620B24126780D2DBE6FC';
wwv_flow_api.g_varchar2_table(48) := '697BDEB575F5D20E6FFA4AFF3BEA7E08CED710608F0EDF9666CCD1CA14C32B6FEDDA0E47AC5C2AB06656DE34EE71ED7BF5D279385715A8919B0B56A045D599D3517ECC2E9FD01CB71DDA4CB4BEBE711903C09363D205F35CD700C7079A652F6FE834518D';
wwv_flow_api.g_varchar2_table(49) := '798FF3AB754EA9A813D7C13C089A1B0B6D58EB56D4D6C14CCF2202562EE3D847BE0AAF9B65F1E0EF2DCDADD85CD8A13497F798F73ACDF347D7D5F28C4B20063EAC0339723AAA3EF257CEFD4C86929FB469B0AE9ED0A161142A14A9948E9E9D6A5D9A80F6';
wwv_flow_api.g_varchar2_table(50) := 'D274727381DB7DDC68E06782A256113211701DCB5835A35A29986EC26BEAE8B67698B05CE2B26B00DEF4C38F7F4C2215154A63EBE039D76C407003603940186BBE02E7CA44196AE9853AF9D61C46BDF82E2CB5B7ECE82C07C4C4F00DA96AD862ADD39320';
wwv_flow_api.g_varchar2_table(51) := '4DABE292431B601D5D2230468526476F4B2B36EA9B10335600A99188247D78EDAA7CFB6B7F29E3B73F944835A0602050DB996F6AE486FCCEA1AF48C3277F4599719AECEA9A1A044876C9A5777EAA008600F92AE08DC0496BC3A6024D32411388D27A0C2E';
wwv_flow_api.g_varchar2_table(52) := '6E0D324DA8A22A8B283A372D1F7BF237A41BBB55D58874312DDBC5FC8C7F7FE6C87139F7EEDB72EECD9F58F1E8453DEE6C91AB76A1CD44EB68B1328518293144A13A76EE564E10B5970737D519AC9845E0A376730B766E6AA4BCA60E71E01AA96E68C4B9';
wwv_flow_api.g_varchar2_table(53) := '4EED1CCD60EEA67673A78967EE1C55D6D6ABC7774218241C3C43039794D6B35C3A7336B0642209F33CA83C6E0648E85C11641CBB539DB0260FEFDDA7E66A0E1E1EB414B57575F2E8CFEFC7DABB1D3B5E13D67CACBE75C72F6D800B9D82A88574AE62F060';
wwv_flow_api.g_varchar2_table(54) := 'EB9BB649CFEE87108CA8560E56044B95244CE510F6762141653A293E3A5C6A8D8A6B6AF4B5810BD8BE1B553B4EDCCAE39AB71566BB13716CB5B1E0F7A93C83E7FBD52E143D6F863F698ACBA1C9B3D8D4B87CE19C824E736D9B63D53780667D4C5B86AD48';
wwv_flow_api.g_varchar2_table(55) := '3E45C23AD4437D6813070232B883AAA315AE32D15CCAD0216AE2D2053086B1911043C09F5B848C3D5F1FBCA842905C1AA56126695A29546A2B4DF8C4F02DB539CF5DA5A49950CE11B59861493FC03096CCB9FDC6E54B78C4E79C82CF0D7D96415857A0D9';
wwv_flow_api.g_varchar2_table(56) := 'AC83FBBA8C5CD9B89877F2CE1D1531A359B6E77E3528019D5640ADC3013E9BC921E4525E6A036C0B63A59DB1E7B430E6BE89D161F9B7D32794AC2844429A85E99DC5961E41AAB021E1F25067D66E202851296FFCE0FBF2FEFFFD547D26386A717476161E';
wwv_flow_api.g_varchar2_table(57) := '7195CA47581C10DFFFCEAB52515DA3CC33CB60FD3330FF74E4B81F4CB36D1FE1F22AF9DF1FFE879CC51CCBF6CC1F56BDFC3C83F029AD8815D29C4F51EA2B6D80B5748430611AE7A6A7B1A4C163ABF84CC15343F88406E12E7E587967B14DC8E590C29FC9';
wwv_flow_api.g_varchar2_table(58) := '1B44B891D0EC838E1907D10822556A9B0F5FB02EEE28F127570DE97D8F63EEE6C68332C5AA201BAE750EA26D8C59E7E65549F3FCE51C427966BD27B9BB002B8B4BAD0BE099AA3A089382CF586298E5A5B4C382148219C6407048C95A473BA351788E1AE1';
wwv_flow_api.g_varchar2_table(59) := '4B6E43AAF22916D6B5681D30E10018862FE02CD7294D65D2599886430D4E0DE5B0087701CE760A30116058C9416D37F1B3D4A106CBD2C9B2C52CB7DC6C06975C68F3A2758E3A97C8664D34431B603DC6694DC8B4E04EE894A536C0EB1A5C30D76C013A65';
wwv_flow_api.g_varchar2_table(60) := 'A90D70B675EB17AE928036C03ACD8AAB24E4F1C66803ACD3AC785CA605375FA7B26803ACB351054BC8E305E854968200F7F7F7ABB670C58A8B75C69A0616056947016C19AFB4E88200F7F6F62AA8BEB4DFC0059F6D593F344980326551B68C575A6C4191';
wwv_flow_api.g_varchar2_table(61) := '2C7B74A50C338D9182409DFAEB9CEC49E9F54A5BB6503E7679A583A890BC6C8B9D3FF7BC503B73EF2D370F1F188114D5732390298BB1659C5BE4723F1704F8006A39839FA0DF183453C6854828D43B138DAAE767E69F635A6E5396998EC25AE951485ED6';
wwv_flow_api.g_varchar2_table(62) := '69E7CF3D2FA73D8BE421457E9519B729C8D03F1B8D5D08FAD3832CD69631AF5772D8D5AE242F1BA5F60398F9C8E73EFD5B28ECEBE150A8869F09D86E3C3FBBED705BDB94ED8390A2B1F804AE3FF7675F3FF16DCACC29E395C8B020C0B90D38F2D9DFDDE7';
wwv_flow_api.g_varchar2_table(63) := '33D24F61ABA016CF5BE411CA5F49D3D75A9E141EE9F38DE399847FF98B7FF8D61BB9B22D756F0B1E28A5EE800BEBD722D3FF07693871DB203007480000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72342096716797137)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/avi.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000017BD494441547801ED9D7B901CC57DC77B6676F74ED29DEED05B02BD40C84212D10303922B10300139C4761287532A7FD849AA9C0AE661CAF61FA994';
wwv_flow_api.g_varchar2_table(7) := '2BE12A7FA452F9C3E5AAFC93045712179644385CB81C972DE24A425279120A211EB225901048484212A7C79DEEB5BB33F97C7B76EE76F76EEFF66E671FA7DB86B999E9E9FE75F7F7DBBF5FFFBA7B76644C1C21089C38C4D453467777E09AEBA01DC51826';
wwv_flow_api.g_varchar2_table(8) := '8A23A67D2F501C2750BE3D0747EE3226FB796382CE2030BE6B5CA3FFAB167C24CF50BEEAE707416B5BCA5C5C758379A67BA7F37ED7E6C0EB09023F6A4FD5EA5D43C195695E1EB90FBD34F0881338DF49B6B776D4B0FE151595A55B76A48C59DC923998F4';
wwv_flow_api.g_varchar2_table(9) := '135FF9F60EE764F7BF0689EEFB4CF67A21B92282BB9EA7C7EF75B27B0E062B8D19FE69AAA365CBF095A1344267A85715F135ADCCD4D1C9F8C6EF98EF0EDEB834D5EEA733FF930912BFFD57D719C91512D16341F5FDC19B31CB9F48F7A50DC65A321BFE40';
wwv_flow_api.g_varchar2_table(10) := '79D5B9ED1095CD64FA5B3A13BB3C27B3EF89C3C1FAEEFB9D4CF7CBC6BB1EC6E48A08DED2D565C75ECF710496C662FBD75E870086F10D783D5A53633C3AA53374396352ED894F05FEF545724504BFDDD323024DD6C36541852DC19672C5367618AB6640C5';
wwv_flow_api.g_varchar2_table(11) := 'C32165F86A26DBB230B13B30997D4FBE19DC224DEED2B359EC5D574470A4C1392A1D80686C56F36A677BE6D87DE0B8AEFC2AC792DC96D8ED673307FEE0D0D0AD3D8E93BDEFE59767ADB9AE88E0317CA2AB22D8A2E8063C1775C5B0E2F21F18682CC9ED89';
wwv_flow_api.g_varchar2_table(12) := '3B138EB7EFB1B7830D2FDF7FFFACD5E498096E4026CBAA52388F0FC2F97C01C94E3AB35F244B9367A3B99EB30417DA9A712B71A324A7DA1277BA99CC734FBC3ABC6936923C67092E30D1B995B82265B7248FF467B2907C4790700F3CF1C6EC2379CE125C';
wwv_flow_api.g_varchar2_table(13) := 'A0C1A5BD64E163C764A650DB035F2407B34A93E72CC1568323359E588335F1530835B9CF6A3224E35DBF36BCD99AEB9EC69F42C54C70849805A6F1FF14A8F104D5D5F38864343967AEB77BAEF30F5F3D1C6CD5326D172407A52DC004426B1B1533C15321';
wwv_flow_api.g_varchar2_table(14) := '56DBC64D565AD9351D4B68CDF5089ADCD29EDCEA0799038F1E1EB624EF6D609263267832481BEBD90C6D4D68AE59F14AB625B6BA81D3F024CF5982C71473DA1D2F9C424993DB925B13817BE0C9D746B6C95CEFEDE971ED8B03D31659BD0C7396E0020D9E';
wwv_flow_api.g_varchar2_table(15) := 'FE180AC981CB989CC1BBDECA9B0DCF3DFAFAC88E9EBD7BB36F6F364E23911C33C105B055AF5BC62DB994173D4939B9D758BCE1BE4C8631799367CCFE272DC90E24F7340CC931135C81E19B04CC467D446BB5C6E9B1766D49E60DA2FD8F1F1ED9294D364F';
wwv_flow_api.g_varchar2_table(16) := '1BD3089A1C33C1B3548367DA83D83DB3243B21C92934D9E0783D7668E4CE6EC7F11B81E498099E3D1A1C4B4DF582431EC9235693131B89DDDF2824C74CF04C55A1F6F90A6CCDF49DACB10A5B92ED2B2BEC26E73479617283EB38FB1A81E4394BF018435C';
wwv_flow_api.g_varchar2_table(17) := 'CDC0C92ACC1FDEA1B996646932F3E45BA5C98CC977D7D35CCF5982017F2C54A2C16352ECB2E628C978D78CC91B0CF3E4C75F4BEFAE17C97396E002135DA9064724E77A4D01C96DDEFAC00DF63FFE467D489EB304479CD8735C1A9C27749464164358F15A';
wwv_flow_api.g_varchar2_table(18) := '67FC00C72BFDA95A6BF2DC263852E3B834388F60ED4259929927DB152F48E6EDE2FD4F1E4EDF6349266D2DE6C931131C2196DFD206BECE99D4AAD43027BB90646F2D3F7CDAC7987C6F7737F3644277C08FDEAA1862165E4DC4E245A196351D25598ED702';
wwv_flow_api.g_varchar2_table(19) := '6FB5719DEF45243F8D6B564D926326385E12AA29ADD6B6C692CC3C99FDE41CC9C1F770BCEEC56C07DD552479CE125C4B0D8E3AAA48E6BF704C5E905C6D7C67FF1387D39F36552479CE125CA0C10537111D553B87245FCBA4536DDE8D38F0CF5693E49809';
wwv_flow_api.g_varchar2_table(20) := 'AE2D52F15130EEBDE8F8444F2C49062481772D925789E4C70FA71FA88626C74C703D0CDFC40896153BD61FED2FD06C1EC5D9833FFAAD55D987F24D915E9223D95AD68C485E00C9BE79F6F137D30F5A92D989EA7AFE79B6982B0F3113ACDACFCA20B32982';
wwv_flow_api.g_varchar2_table(21) := 'C2B3AEED4F61B928FB5C469E700C0E652AB9FDDF2447FAD3EC2727569A8CD9F7D8E1F4677864B4A71CC73C39668285CC6C08631D11350A780DD667F7C7789EEB3B2EFB05353D7875CF73BDCC803FC24F5797F25BEBBFFFDACF034BB29D2B57B8CA56F947';
wwv_flow_api.g_varchar2_table(22) := '5866039FE3EAA88EC84F09F9C9E87026F07A7BAF0D19E3F7DBED7BA595A995E65A7BAA8828447151475647C98BB3F994368A8BF215C7F13C2A23FFDCEBF47B89E4F2F4F0F0B77EFDC71FBDF38387971FD77BD77C47219B2F693AD77394E010227ED06C86';
wwv_flow_api.g_varchar2_table(23) := 'B3A6E5DC50E09981FEC0F7B34C4B65D4C6347C3A60569616D29D20C91B2159D7756E43D64D1CC7B7749920FC50C6CCA4CF6182432D63D075BCD4BC243F1D35CE603FDCB28268499E19A015E5F2B12AA994C96646320EBF91A948562EF31C26580844A6D4';
wwv_flow_api.g_varchar2_table(24) := '0F9C648B85241882641F8B58074DC67CF0E92EDF932EE7BE0F63A2CF64E4F89AF62966276BDAE5374006B0D4E08B3303C98ED3DA862ABB0E9F499305AFE981BFA71E17869CEA157D26237A5AF6B949703E54383CD264675E3BBF29041A3940B50C55282E';
wwv_flow_api.g_varchar2_table(25) := '6682AB50C35A02ACB2EA4D72D4DE5846E0DCE7832299959FC72C4CE5B2EA28A15E24E7C317937714B306D79194B88BAE17C931B7A349F06480D69AE42A8C704D82272358CF6A4972BE899EAA5E653E8F99E02A74C1321B52D564B522B90AF0C54C7015BA';
wwv_flow_api.g_varchar2_table(26) := '6055999B86F05A905C05F86226B80A5D701A1C543DE93892ED8B91F1155B05F86272C6A33656A10B46A21BE59C2359D509B4766D9735636A77BE98C69C07370A0B55AE478126F3E205F7B18798542F66131D7B331B57A02539955BD614C93198EB2AF493';
wwv_flow_api.g_varchar2_table(27) := '26C19574A1029251B96A687225F5236F93E00A010CE7C9394DF62AD4E4FC31B8D27AE5F237098E03C848935BB50B254D9EA1B96E9AE838D8A8928C88646D357A8D63AE9B1A1C27DF11C9D2E44ACD75739A14273331CACA91EC368826373538466E474541';
wwv_flow_api.g_varchar2_table(28) := 'B249A44C48F20CE7C9CD79F0289C8D79318EE4321CAFA617DD985C96AC5501C91578D7250B98FA41D3444F8D516529A64372739A5419D675CB3D4AF2C2DC14AA0C731D53659B1A1C1390538AB12427738E57EDCC7593E02999893141812627C7AF78E53B';
wwv_flow_api.g_varchar2_table(29) := '59CD79708CC0D75254812617919C3F0637A749B56425E6B2B4569D88CC751EC94D0D8E19E8BA8983C9C93459F56A6A70DDD889AFE07124E7D9E8E6181C1FCE75959467AE1D4FE63A47725383EB4A4B8C85CB5C8763B27ED5E830368F921C432931F59318';
wwv_flow_api.g_varchar2_table(30) := '6A32A745E448661FD949B0D598C53E67466241A449702C30C621A4D0F1F2D34D82E340B5F1646808D66B3FF3C24F4A545AC1E64A56A5085625BF584EC722B9614CB49A94F31F4B360C236643742E99B0E8C144B225632A39C5F926CB539C56556804ED69';
wwv_flow_api.g_varchar2_table(31) := '18825B414F9F97D12C41400AB02844F7DA83D117C1323CD473C54F169446204BB6CEA379B84F7333C231998C161E0AA0289FCA1FD24D5ED02DEF6C18A595AC28ADCE92AFE9EC6465F0B8AAA1AE040B04012FE0DE07890B5C0828C51707260FA69D671D64';
wwv_flow_api.g_varchar2_table(32) := '58C021D004E06441B2B3A47907D9573927C9A4B2D48956C3CA4212E87EA220F967C8779E04EA7892D3C1791588492EB7F610B9EA70EF91B68FB3EAAF4EA88EB091876D939441B2AA87BA121C11200077CD0B4C1B80082CFB15C1BCA68B1069DC55C0FE20';
wwv_flow_api.g_varchar2_table(33) := 'ED9857703057937925B5577A9184887141F1927DEF82C0CC27BD8057990A67461C731152443A22C605A5DDD61A980ECAD073C91F42E0C961C7CAD1BDC855BD54DFFB7365A83E0A2D1474967A9EA1BE0925AE53A81BC1C22145C32F01DA72C0F8D2DAACB9';
wwv_flow_api.g_varchar2_table(34) := 'A5D3378319877FD2A00874124B830640FD32009FEC73CC3F7FEC9AFF1B70CC1A5A30117E92FD2E7ECA176E08CC976ECE98B6646046B2A1EC841B98D72F7AE6E9139E59443A919EE3C55E8B2469E3DE9BB2E6F6C5BE49932FE905E6CC35D7FCC5B184398B';
wwv_flow_api.g_varchar2_table(35) := 'DC0EB14B9A13D4E96B2B7CF3D935594B649AF6B492B6977A7EE778C21C193666853AEE5C2458C04A03745E84B62C430B068810C10AF9C4F12D3A22C2CF856E5BE2989D4B7DF3FDF73DD3D3EB9A3545002A1F5F05341739EE5AE49BB50B419DEB0CA640CF';
wwv_flow_api.g_varchar2_table(36) := '52A4DFBA386BB69F75CD213A892C81EA11055D8A901B98A92C9BAF8E1140B031C3084D20288D1499E26310FDCBD4790F1DE1A6369FEF5E4A5BC3CF99FDD7479EF9DF7EC72CA27192A74365D73A08DBBA0435568D560574163883A02A0DD631CC218DB387';
wwv_flow_api.g_varchar2_table(37) := 'FDE81C24703F44BC4CF6860EDFFCD6FAACD90D011FA14532B55190599665F8253ACD06C8CD70DD8FA98CF25FE3BA9D417D5767604EF02C2FAB15A17BD58B0F95DABAA84C1DC3D42F4BEAF924B8CA330D29D272917B158D1DE2B9B4FF3FCF78E64FE97CEA';
wwv_flow_api.g_varchar2_table(38) := '64AD085267292EC31654833F7533D16A5B7EA3F944B31D2F056C4BCE1CFEF739D7A421775E2230EBDA03B3E906DF244990065C01BE6A816FEEC1843EDFEF999539B0D459C0DD1C23CD6F2EC12AD0015492488FAC85CA6D41E66686848D94A1B155E324A7';
wwv_flow_api.g_varchar2_table(39) := 'D1A05CB224AA175F7F0DCF0CB61EDD51D6E434899FC234EFC09264A9A3C2028681937DAE3970CA338C026605E80E720E9FDA2435FF233C1B2484300858AB818C5DDF4613BE7C8A710FC09EFA79C2BC7A5ED4F19C5A2B9DBE952D33BA847B8DD192A006C9';
wwv_flow_api.g_varchar2_table(40) := 'BB56DC363A843A47163244DEF1AB6821C42B28AF34EF17DB02738AB852CE9695AAC290AE933AC25BA8E40398E687D05EC997CC56C8BC8CE3F6229AFBD235C7ACE6BE784A2529B50EC2A3418245D1D645572279231AF1E994319B30A7AFE291BE7E09330B';
wwv_flow_api.g_varchar2_table(41) := '532252665A90CB2C5E214E0D513E117596B87BD15C69BDD2EA188184572E78A60F123CD44BA42F44F61D68F159322AAFD28D0F7AA28026F377006D5D4C3FEBCA9966591259158DEFFF4687FCCE45D76CA5BEEA70A5655A8135F9D3400417C22B027B1973';
wwv_flow_api.g_varchar2_table(42) := '353F3E2BADE3F1CD689BC0147029CCF835C07DF30A5ACC334D5522408F737117C4C971CB408808FD78C8313FC1213B8D76C9F48A8024F19F602CBF3B15D83135B40FC5B893D886F07C91BA3C8A59DEB94C637B18270FFBCD8F3DF3CC69CFACA27EEA645A';
wwv_flow_api.g_varchar2_table(43) := '688C72E604D4E5D440048B9EB190A0661B206817C7EDCC91FF9669C8EEE5727144329E2DE04A63FEF1926BD6630E35BE7232FD68E6362E36E340692C97A3A3A0B1F1E0A03147AFBAE40DC1D7A39598DADD68FA71889BD84C870254AEACC00ED23FBC9ACF';
wwv_flow_api.g_varchar2_table(44) := 'C4235BBE804CF4E97ED7ECC3346B616431F1C36469146085498C2187660512D5EBE5EDDE0890DFB80DC41029301760F6AC8305B16799DAFC1472BFFB916B9682A4C024A59DBAFC0CD5D90BB91A5F551B69F620F2DE46D315DE620E7D69C8354B5A430DD4';
wwv_flow_api.g_varchar2_table(45) := 'FC783BE983DED00356AAE25648863A8ABE11FEB95559EAC69408EB212B7209EFF9471F78E687C8DD89C91F626C0F4BB2C5D5FD4FCC0457DE340B26B0C869694BA16A0A802B73A8E98EA621BD98DB4B8CC95AB61CE07E21C58A6499DD01CE3B70AE3A70BE';
wwv_flow_api.g_varchar2_table(46) := '9447DA7E0E0D3B8A69DE854CAD447DC8F58AF98CCB7486141D4753A9DD2C3D9D667C5E469AFC39B18A57C842DC122CC9320E3B27274ECEDE892BAEF9EB0BAED9443E8AB7CE9CEAD22821E6BAA88995077513694CFE3CD881288D75296ABC7D49D63CB525';
wwv_flow_api.g_varchar2_table(47) := '63FEE4D68C598506F642FC3C327DCCF9EE96C06C8430116BCD33F1472F3BE6BB90AACEF013BCF343AC82C9F3B56331793495BA7B61608E722DE7AE54B0D333F245E3BD1CB535EDBEF9228B295AEF169831035AAA2A65C7D3EFE20C93A053663172AE1210';
wwv_flow_api.g_varchar2_table(48) := '798E65C157F148355ECA3477E2086DC2942ECE394E2270D78AACD5EA3F7A57EB4BC64E773EBB28302B71C67CF289402DA07C38E89887C9A779E90688B880F6F7B1D8D1894995966BFE7A3B4ED90ACAD39C58F90AEC74AE4EBD98F623975DB38731D8CEAB';
wwv_flow_api.g_varchar2_table(49) := 'C9BB148DFE0D96598F316CBC41396BB108EA488D4274CC0497C9E224C94494C0FB184DFB33C6B63730A39BA9E51180FF3A047F05AD5D81C649BB5B5884D05AF1C3170273A0972547DCE05F204D3B84451EAE887A70956FEE635142C4D9E91567590269B8';
wwv_flow_api.g_varchar2_table(50) := 'CA53FC3A347837641D86242D5D2A3E0ABA26899D03FF808591D5F8073B9766C31537EAB10E8BF13B90FCCD7712764344BB5D536D4546B2AB7D6E948E9683306CAE0015C99B20EA5E34620BC7AF727C8B79F011A63A2EDA1B3A3E8E1DABD7CFF7CDBB68E6';
wwv_flow_api.g_varchar2_table(51) := '7608BA05B095379FBC5510B21E02D7E02DAFD51907AC95CE409FB1412B51D2C43B3A02F3219122732C84779A5127C8731ECD7F8E8E77113F40CE9FFC02FDFB1D5A1BFFFD9559F32E265C9D4853AEFC4E3226AFB6570D44F07838046D54C1E8A9882D0E36';
wwv_flow_api.g_varchar2_table(52) := '0E276807E4693C8DB45779356E2BC80113E9F6B064B171802CE51549AD5ABA644E7C0BDADB074958EFA280A74DFEE5A4FB4B3CF27FF9D0C3E1C393A6104D9F5274BA0759FCF82216E4089D4D53AE09AA5A24B3FAB70D64A2C7E0D095083986B61CC2446F';
wwv_flow_api.g_varchar2_table(53) := 'E5FA2D40FC3A5B7F5A8FD6322351164091730EB36A4410E3E87CCED1EAD23580FE19AB57035A6DC29C93D4E691172C6237927EA9CC3DE954A634FC93DCFF88254D2D35AA8CB1109629EBB005520F9CF3F0BE03D6A2B3D6C3D658BF9471FE91B519737430';
wwv_flow_api.g_varchar2_table(54) := '614EE1916BCCD772A564D72B3410C1219C02435312AD317FF5C62C5B749861B463312A751BE42E870079B34AA77DDDF34C815EC4F17954E6178F56415AAA67A7D984F8631CB0FFC0A9FA242DBD423CB323BBD7AB5DA4176E31E65720847F90CACEBDE5C0';
wwv_flow_api.g_varchar2_table(55) := '6D438B9FBDCA8A14E94262542F5DC948938EBA697FF7433AC5F75923D79C585327BB0306C9EA34BF8B13F64DF682AF5186769334ED0A6521A6C6A1AE040BBA28482BA37153042E01ECCFE1B828081C79D23A6B2D5A4E915690B4F97F90E5C157F8A7251F';
wwv_flow_api.g_varchar2_table(56) := '5DE99B4E3A853449CF355FD6E6C27988D8C3F82DCD5B9493B58673806538C2F37BD0B479A02033CB3F706736320E6F3D8B55088BA64EA1E646F523AB75A0B47AF602F9B7B2E0F205B62D553F79FCFA574C772DF7CDEFF5F9E60F71C81E50D9E49138D5BF';
wwv_flow_api.g_varchar2_table(57) := 'D6816AC519F2299B5CAE52AAC16062CF5A156A01091DBAD65B116D90A863018736D2B575A7B152DAF9014B8FCF9F48983F6735EBD770A276E04D2F642AE59146AB53D2281128F9F368A5CE025A658AEC65C4BDC5DCF822E67D3EE935966ADCBC150DBE0F';
wwv_flow_api.g_varchar2_table(58) := '47ED188CD87A509E9CA9F0904F80494786805BC79F6731D56F30AFD6F6A33A9DBA432773F1AEF519F30D869433C8515A955B8F10B30697DF0CA514E87AB546E78F007A01808B1869813A809C9AFCA0F156BB41EF40DCBF03EA21F2AC20FFFA56D2723E85';
wwv_flow_api.g_varchar2_table(59) := 'B9D64B0322EC246BCE4790B78878698FCAE0D2CAD514462FC3BD8FACD7F1CAE763FEADD9A75C69FF0AE4B5F3FC3CF2B5EAA5A55379D01AEB31E8D601D37AF30DC41DC512BC881569A773C982C812A81C117E179DEE158609ED09EBCD4EAA5673A26326B8';
wwv_flow_api.g_varchar2_table(60) := '88111A542A08048D4D7A535280FF1D8BF5F3004A665A28E8797E50BC36122EE0789D0229AD5CAD02E02C449C62CEFC37B9C50E750A91A4372E2E434C2769F2E7A4922BC2A5ADFC0AC8F49CF56C67515976EC265E5EF4DD2073004FB91D0D55E790160E73';
wwv_flow_api.g_varchar2_table(61) := 'D1CFB3C82288E475A43B442738C77E7527D7926DA749C8511EBDFD2182A30E46544D43CC044FAFEEB4DB9A4B9D8F329E0A08F8B05A562C099C2C607A174AE39F088AD68C2FA3F527B09B922350E5816BB1415A582A28ADA6499761E4240449BE0E8DDDD1';
wwv_flow_api.g_varchar2_table(62) := 'ABB95AB7BEC6BDE2951E05B52FDBE95E21225EDAF91ED660105F40E65F4175535D17D12095A3FCF50831139C6BDD345A12355C9BE893F051205124487BA2D244F68DB444F792A7B3C057BAC9821E4BC3DA8B50503E69A28896898F42B1CCA81CD57B09F5';
wwv_flow_api.g_varchar2_table(63) := '77D43BF3823A9AD5E8BCB85A5F1635ADD2E2A7407412F102753AB9F370B7F9A431C5F9F3D3942A5A04147704E5D351FC6C22798A53B91A068AC344E98BD354FB3E66822B6B5265B943526602D864E54EF62CBFAC72D3E5E7A9C575B956B1CCBA4CD08DCB';
wwv_flow_api.g_varchar2_table(64) := 'CCD94C561D046226B851FB7175C09B0D526326783634796ED5B149F075CE7793E026C1D341A0E9644D07AD89D3C68B61451AFC764F4FBE5715BE663171AD9BB1E522C07A78FE84BE08E372A58CA6AB88E02D5D5DB6BB7959D58AB5012DC2E6533E5A4CF3';
wwv_flow_api.g_varchar2_table(65) := 'A22C04845D0EC31CA626C2B8ACFC1324AA68A123EA5DBE9BF09D80F520558EBFA27A82B29A51532120EC8421286683F022C278AAACA59E5744303FC1B2729D60E43D56928F26DB935B86AF443FA62C556433BE14027AE721D59EF446AEF8475DD73F11A6';
wwv_flow_api.g_varchar2_table(66) := '0B312E9567AAF8CA0CAA5E7370D861273CF4E381471CCF7D26D9D6D23955A1CDE7A51148F70D5D099CE0CBFFB467FE0B36551EC6A573957E5219C1929B57813D0707EE6210FE3C919DD0CE8BC8150DF1A56B7D9D3DF1794B5FEF1A80DD65361C7FF8D267';
wwv_flow_api.g_varchar2_table(67) := '52AFD826E6615BDF26AB22CD102F023161FAFF7D57A68883B426F30000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72342557963797143)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/bak.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001782494441547801ED5D5B901CD5793EA77B66F67E9184EE128895D005C91612480924B18DC1167625380FACAAEC4A5E5249D90848555EF3106F2A55';
wwv_flow_api.g_varchar2_table(7) := '899F5C79209732A4ECA22C89F29A94E3C45824AE82AAC484082CB12210A9045842486885B4D2DE2F33D39DEF3BDD67A66776677766FB74CFACB68F34D3DDE7FCE73FE77CDFF9FF73E99E5E214C04D79526D4D453475F9F6B89DBA01DE518A6CA236ABE26';
wwv_flow_api.g_varchar2_table(8) := '2852BACC77E8C4C44121E4E342B8DDAE2B1C4B5882FF230B0E342F523FEBE7B86E737B465CDFB0423CD7B75F5EECBDD7B5FB5DD7D1ED89ACDE312A0E67790172BFFCF2C413D2B69E4BB73775C758FF5045E5D12DBB3242AC6ACA9D4867524FFEED2E79A1';
wwv_flow_api.g_varchar2_table(9) := 'EF5537D5F70591BF5D480E4570EF8FD0E30FCBFCA113E3EB85B0FF23D3D5B47B7A782A0BA58BB4AB507CD5941975943947385DADD6E4C6D5990E279B7B23E7A6BEFE8FFB6E2F924312D1AF40751CD903B7BC233B9A1570D6D4D9F01F182F3BB71AA2F2B9';
wwv_flow_api.g_varchar2_table(10) := 'DC585377EA376D993BFAF4807B77DFC332D7F79AB06F87313914C1BB7B7BD5D86B4B49B03816AB6F75EE01E8C537E079A1A6703DE89472EA564E643A520FB9CEED45722882DFEDEF2781226F63CA021356042BCA19DBD8A1584D1715F78694E9915CBEA9';
wwv_flow_api.g_varchar2_table(11) := '33F5A02B72479F79C7DD4A4BEE65DA129E5D8722585BB04FA504108DCD6AA076AA6716AF5D69599C574945727BEA41279F3BFECDD353F7F44B995FCA248722B8888F3E2B834D4737E0B1AC2B7A15E7FC01038D22B923752025EDA347DE75B72D65920D13';
wwv_flow_api.g_varchar2_table(12) := 'DC804C5655256F1DEF7AEBF91292653677ECC8AF962EC9CB96E0525F336B27CE23793497C7C4EB8065E75E7C72C0DDB1142D79D9125CE2A2FD9DB83263273672C623F97ECBCDBDF8F499E99D4B8DE4654B708905579E252B923926C392EF731DEBF8D367';
wwv_flow_api.g_varchar2_table(13) := 'DC2545F2B2255859B036E3B92D980B3F06E5AE9525B793E4DCF123EF4CEF5296DCDFF84B28C3046BC414308DFF5562C6735497E99A64BAEB315832481679F9A33F1D70F7709BB6B7C149364CF04288CD01629DA2AAAE695150B96B5A7253477A8FE3E68E';
wwv_flow_api.g_varchar2_table(14) := '7F6B60BA40B25BD9CDD7A9855EB18609AE6B5B6A2A7C91BEC673D71893D3EDA93D962B0B241F86253722C9CB96E0A261D6D42F285C584235B5A7F7A45CEBF8374FCDECA5BB3EDCDF6FA907076A56195D86654B708905D7EE5E41B26B614CCEA53B527B52';
wwv_flow_api.g_varchar2_table(15) := '362CF9ED997DFD870FE7DFBD57C84622D930C125B045D72D4D6BAE348B9EA71CFF31161B6372AEA93DB5CB16E2D8338A64D950241B263884E39B07CC464D426BB9C769639D9CC3C46B279E203AF6D45B33FBE9AEC5B78568044B364CF012B5E0C5F620DC';
wwv_flow_api.g_varchar2_table(16) := '3D53244B900C4BCE80649192C78E9C9E39D027A5D308241B2678E958B0919AF201074D322C794659726A07621B8664C3042FD614E2CF57E26B6A9F64152BAC48568FACE06EB2E7AE339DE96D9694471BC192972DC1458670B6884956697EEF0A96AB48A6';
wwv_flow_api.g_varchar2_table(17) := '25639D7C0F49C6C4EB603DDDF5B225B8C44587B1E012A68B96CCD9354976A475FCA953D907EB45F2B225B8C44587B5E07948CEB4D93DAEE51E7BEA4C7D485EB604977062D082B5DE82BB56EBE4F416E1D487E4E54DB03663C316AC4886EE02C9D8F1CAB4';
wwv_flow_api.g_varchar2_table(18) := '83E4BC7BFCC8DBD9DF56EE1A4271AC930D13AC11D3FDB8C18F2503B1E1BAFABA15C95C4291E48EF45D7884FC18C6E4CFF5F5619D8CD0E7E2476F1106C3CAA344CC2C0A71D6B440323743DAECCD78D4FE879AE46F63251D25C98609364B4294DAE2F6358A';
wwv_flow_api.g_varchar2_table(19) := '64AC9339BBCEB48264CB5524C3A2DDBE08495EB604C769C1BAA39264FCF3DC755B1A246333E4EDECC35C874745F2B225B8C4824B2E341D911D3D92C773D94CBBBD09173F7C7A20FBC5A848364C70BC4899A360D673D1E654CFAD890E2485891749DEE038';
wwv_flow_api.g_varchar2_table(20) := '82EEFA912848364C703D1CDFDC0856155BEC8FEA17682A0FE3D4075FFCAD55D51FE65B409E9A0BBAD5AD464532EE27AF87BB7EE19953D94715C9B813656AE2659860D67E4906BA4D12E41D79AE7E0A8B93AA8F55E4F1C6605F272F54A969B5848225E72D';
wwv_flow_api.g_varchar2_table(21) := '71F4C840F63122D84792F9DE909021B482D2F289CC5208C58E883BF6AE6D49073706846D5BD83AC6FD82583F7874CF96766EC29969EE48ADC16FAD7FF067675D8F64AE9543EEB2857F09CB52E073561DD911F15342FC64743AE7DA4343E353423863EAF6';
wwv_flow_api.g_varchar2_table(22) := '3D65E96A69B9CA9F3242071DA73B323B4A204EE5A3AC8ED3F9CAE390AECB081E87E4989D4AAFCD4E4F7FF7F75F1E3CFF93AFAEFD80CF5DE33D0AF9A0A65ACE9729C11E44F841B398CE8BA6AB53AE2D26C65CC7C963594AA756B4F05AC00C270BD2A59B16';
wwv_flow_api.g_varchar2_table(23) := 'AECC5B96DC055D9BF0F96077AF70BD17652C4EFB3226D8B3320CBAD2CEB4A4F1D3512127C7C02D761015C98B0334542E075E259311F9DC4C4EE23732A174F9999731C14440BB52C795E92605893B391A20395E4B86FBC0ABBB1C9BB6ECBF1F46E8D764F8';
wwv_flow_api.g_varchar2_table(24) := '7CD57C303CC9AAB9FC06C8002C39F862320392A56CE980295B12AF49A3078FF583F91E7B9C177CD32B7B4D864EADFA98101C840A131E5A3248C6EF17000D27407186088A334C7004358C136096556F92757B8D8CC0FC9D8DD150F43046D5C6ADAC5E2407';
wwv_flow_api.g_varchar2_table(25) := 'E133343B324C70DC4C44585EBD4836DCA484E0F9008D9BE40846B884E0F908665A9C24075DF442F5AA32DD30C11174C12A1B12A9585C2447009F618223E88291325783F238488E003EC30447D0056BE02072D15924AB0723CD151B017C8626E3BA8D1174';
wwv_flow_api.g_varchar2_table(26) := '41ADBA518E3EC9AC8ECBBD6B07377AD49D2703150CC2D798EB60038D5C0A2A4A2C19BFEDE70D0AD3C190E91976D1A65BD9C0FA14C9197F5B136C98203902179D101CA60FCD22390286C2D40F7913824302E8AD937D4BB643BAEBE0181CB65E7EFE846013';
wwv_flow_api.g_varchar2_table(27) := '406A4B6EE65DA810EE3A020790106C8260EAD024F356A34D9223606B11754D085E046815B3689269C961DD75B24CAA08737D137C92AD06B1E4C482A3E80E74CFA98CF048E6C46B11EE3A590747C18C419DB348AE62332499451B24200E55252487985D87';
wwv_flow_api.g_varchar2_table(28) := 'A86BE2A243805755D602C99DFEEC7A1E4B5E84275FA80E09C10B2164225D919CF6C7E4782D3921D80481D5E82858B25E27CF63C9D5E8AB522621B84AA08C881548A6BB4ECFBE41119C6425EB602390C7AFA4C45D97911C1C83936552FCDC182B91B71653';
wwv_flow_api.g_varchar2_table(29) := '7A4C0E909C58B03188EBAC084CCE67C9AC5D62C175E6C844F1B3480EF8E8640C36817003E808B86BA9265E3EC9890537003946AA4077ED8DC9FC55A3C4D8BCA8BDEB0A7531D44F2A684FA2AB44C02719F791650AEBE43CFC736EA6CABCF38B2504CF8F4F';
wwv_flow_api.g_varchar2_table(30) := '8CA9A5132F279B101C23F83116C521988FFDB478AF94085B72B2931516C148F293E5AC11CD7575D16C863F67ACD818382E15F4712EC14A7A9867BE7C5A57A5FC4C2FB780F964B5BE6ACBD5F2511EEB4630814A03898CDF3A5E070341D260F22D60395C70';
wwv_flow_api.g_varchar2_table(31) := '7B7E2EC29A11C957D37059A9F3F148F9E979F22159958179ABC8300302CB64D07A989FE5F39A1F9645D2B51C4E0B81BF60611DB884CDFBF998C87CF50A752398200D03B94B6401612E1028D3864F174E3AF06981D04C19E004FA23207A0D7A9A08B0AF8B';
wwv_flow_api.g_varchar2_table(32) := '722B70BD1E4FCC90FCB93A0765912C469178011F8815EAC134967F1704482A033BD90594358E630A7194290F2D885811A86F164224DC57512E1EF975DD0826589B61BE07D2C517BD96B7360FD02720773527C5FF61524990EE418D59695A153F24E8408B';
wwv_flow_api.g_varchar2_table(33) := '2B3A71C26B06B541046112F7D1B454D6A42CDC4B2E7C93405AE85A28BCBF092708DEB75716CF2F213F3B22ADB305191E4159B4762DA732F95F2C7712650E42FEFC0CF2E17C2774331F3B1CEB1F772056B106828A768BEBF87A62555E7C75134ED078C611';
wwv_flow_api.g_varchar2_table(34) := '802070046C0A608D64A5189C90E2E49025FEF596541642ABBE86B49520F60FEECC8B1D2B1C31898E80375C2982D3B62B4600F23F7D9012AF0C4B7117FC30AD49075D8F1B28F88F36E4C5C31BF322A75E8DE549B043B083BDF07E4ABC8432DB70BD15E47E';
wwv_flow_api.g_varchar2_table(35) := '6B5B4EAC6C764536CF77E479B205B53899419E61CC8FAE4F4A3170D3123FC56712F5A455D392E30EB1125C0002AD9CC245074A5FDD0A44708EB7F829C07CCC140E9427C90472F74A21F6AF96E2DE4F6CF10F1FDBCA5D329DF2047C4D9B2B26C0A02698C7';
wwv_flow_api.g_varchar2_table(36) := '5520647F9723FE65D856E46A52998FE3FF5520BE35E38ACFAC72C43AE49FC4355E34ABCAB4214C825BD15126F17EB266E4A1E5DED1EA8A558A60BC538B850702EBCA80D7B8AB8EBA7FB523EEBB6E8BEF5DB4C4203A293B25B88E35C44A70B065B4902C00';
wwv_flow_api.g_varchar2_table(37) := '9C82D511184D2489D1B8E97791E5800AE308EC5760AD376199DF1FB404578A8C9F82354DC26A68C1D4CBC00ED39272C5F66E57ECB82AC40D907707AC9D2E59EB1FC4F9E3EDAE580BD2C6A03387FAE075822AAF269843094122992487F56547C8B24E8863';
wwv_flow_api.g_varchar2_table(38) := '79AC3383EE5CAC2F433BBCC6EF6C80300692BF822761D99C27F8C94A26EAAFBA118CB62A400810701504146F7E15AFC3422F8DC325626C5E8971F1B3B0AE1560929D610256D08AF8DF589D173FBF61898F302E93341B56C7CEA0273ED44D7D7C13E1C676';
wwv_flow_api.g_varchar2_table(39) := '47EC8575BE74538A559065E081636517CADED3E58A0E58315D2E99C77F91425E459A7F4D7D0C4C637D559D21C3E3851129FE176E388DEB4ED46D2BF4AD81E7600763476886D0FDB0E4C73016BC883A6F01E2D4A375526F9401D5AA4F602319D850CF3DBB';
wwv_flow_api.g_varchar2_table(40) := 'CA827E09109EFCC8167F7FD916BF773E257E7C212546619D0490169383BB5C81C9D95AB8CEE1024A9E1720E013E824373031A247A08BED00E8F7C14D93308E8F2497724338DF8D0EB415698C631D6E4E8314E4D79688E85981452A6F8313D6E7E2A825BE';
wwv_flow_api.g_varchar2_table(41) := 'F1A12DFEE6A22DFE1CE3F577DE4B89F318B3D949580E3B263DC95E789209E4A5F522FAF627B8D842DA991708582788DB068BEA0131F7E3FA674312C073F2E48D8D16329204CE90B96CF20261F70027F89FE2F5DE2493FA28B2BDDB11DBA16F1469045D91';
wwv_flow_api.g_varchar2_table(42) := '89F3FB7CF7CC6B12F129CAA19B6619889A27E85417FAD049D043D640EF1A90FA3C2674FF39682B6FE47911AF0E9D6813BD0DD7C7AC133F7184BA59B06E21E6A2857612B66900FC3E5CDB105CE65B20F20016C204072FFC556E97E2E7862DF16BB8EB6E9C';
wwv_flow_api.g_varchar2_table(43) := '431CC1D3C1FC74D337A7A418473AC1E7CC783D5CF43E907913C2B4564EF0BAD1F23DB0AA565817C318E4AF62A64EEBE5383C7FA01025BC99742BCE69B11DE89CFB30EEB2A37813B6A2160E211C7FBDFA16E3A33EAB1FC17ECB82B642CCE87E7F17BB053D';
wwv_flow_api.g_varchar2_table(44) := '709F7FB9C6115FDF92135D2098210300CF61BC7BE98A25F0D25FCF1A558A974EEBCD80C1AB58A25CC1384E9E689D2471EF0A5A9B6741DCA8A07BEE817B6699FCA2FC27C8C7A1002F6D565A2B7F79DE848E96A25C7EB19C6974A6D3E89C5DF0164DA8871B';
wwv_flow_api.g_varchar2_table(45) := 'D0C349D988DFC1A877A1122A975D5B8AE149560DD50E8892085A5A06E07EEDAEBCF8CAE6BC3A2731CDA821FF2EC52D4CA84E5D4F891F5CB2C45558DB0658CAC765FBF1C4336571B9838D118C839FBDC31B7B09C93D20F35E14C0E50A09DED7E18AD5FE64';
wwv_flow_api.g_varchar2_table(46) := '88FAE915C639D693188FF679902CFA1DCE09CE72328536E08F3E882F613DF51026551C77D55A195AE8963F4607E2B0B289ED419CEA58F394602AC930C13554BB20EA81450B20D1045D8DB76821DFC9CDB19168D0850EC2F5D20593573596157478701038';
wwv_flow_api.g_varchar2_table(47) := '5A295DE17F83E0C730695A09C0D979B8147AA0D315CF5E9362335AFD196C8C34D35F43F930E4DEC4D8B91DAE5CA9A4A2050245D831D641EF77B159D38C8ED5854EB71BE3FD1694C33295F780357F3C6689D730795C0BE5D4CF89565CC130C15520E3B7AC';
wwv_flow_api.g_varchar2_table(48) := 'E8BD9847C1AA5214A1FE3509E78E541E606DC218FA8DF6ACF8DC3A4B1CC3ACF517B038569E3983A572AC6E469EEF03D43FC16755735E11C1B8BD00FF12D6CF8FC23DDF0D1274CE2BE3B6786E548A6761D5EC4F8A771C2B05EFCF0D7B04D2337026CEE0CD';
wwv_flow_api.g_varchar2_table(49) := '9C41AEBFE4E2928EBB693FBB648B9318DFEF4485E32457D549D5CCD85791A885540625D9D36D58C00C80F9D5A796B882B190D64597BDADD31177027824037C297A70FD875B31913A2BC54F400A67A6415DAA519C59C06DD24DEFC41D075A3D03497D046B';
wwv_flow_api.g_varchar2_table(50) := 'EABDD0C74D137632BAD8F3B05E472DC51081FFB314AADCB3BF28AA4865E5FCAC8C539D122797D1C1FE0DE43E7FCD52AE991A7C87C4D35882610BAEA1CE3EE874D00485B3572E515EBD668BEF0090BDB0B20BB8DE8741F12FB0FFFB00265CF81B7F6AB363';
wwv_flow_api.g_varchar2_table(51) := '639B23BE88EB67476CB17F8E22A98FB782DE84957F01D372BA675A36B7343F8F0EB21D0467480AC2309654A7214752E931542CEBE6252B99D95F14F0FA013767B2183E18B8EBC59DAE515C7F880D901368C7AB187BB70165F6395AAF2749E97842FD080E';
wwv_flow_api.g_varchar2_table(52) := 'B44FC34580BBE04AEFC6AC793BC6B31E00F61AC6C75F605DB913636607E2E8C2395292B42DB0DEE00D04AD92967927D2DE805BBC082BA72C09E30CF92076C6D6F3DA0F97C72DF1E61876B9E83E115D0D016A7881203BE559CCEA5FBE62E38E11FE061386';
wwv_flow_api.g_varchar2_table(53) := '92EBF01C1F6099348049E12694B70B75A6DE7A90CB26D69DE022D41A726F0C54760DC6F1476E007A11798F006F32547C6AA99416EA6C47149725EF8000CEA69B00369F4EDD858EA29630D0CACD90B3B7B0E509F4D795AA2856A6C219C53916DFC0C4EFAF';
wwv_flow_api.g_varchar2_table(54) := '31ACACC3AC99F7823B91C035F64110CBDEA23B608DEA2B945A7B74DD092E369C63A214231887DFC7C484409D0701BF8575F1A36B61BDBE85794D841C2CE41C88D9AE5A30BB9B205959D0FF607C3D84317D33F6A4897837F4A9193B3ACDAD694BBC8574CE';
wwv_flow_api.g_varchar2_table(55) := '6EB9ED395BCB42806269078F7310C3C946780CE6A7A5F2436269E9C5F62DA42B9AF4BA13AC41D53B550FC1DA9EC552A98D16014BE02CB5071BF824857BCBB43EDE23A665327059343BC03A11D94D370D0BE378B8B1DD73A9749774AD0C97E0BE7F0937CE';
wwv_flow_api.g_varchar2_table(56) := 'A7363E816B9D5395275AE1DBEB94BCA7BC921E0252FC683DFA5821732CD175255803C296728245B21E5A97170FFA4DE70C953360A691186E7AF0AFEE9EC41DA71320F8011043E2D939B42E5A0D6057D6C32E0011711AB2BCA3D382FCEC242C87B718DF83';
wwv_flow_api.g_varchar2_table(57) := '7BBE8CCEC2A744A8871E04C92A6F411F8BC447074FBF278FBF1BAACA651941192DDB0847C3041396EA020923794D7071C049014590B475510BB511786E3F32704D79723025BE87A50727C1BC014F423823A6659319E6E7CD7C4C8E55DA46B0FCFA8825BE';
wwv_flow_api.g_varchar2_table(58) := '0637BD1DE32F49CFA0D59731B17A03EEB90711248DF229741ED647EB65D9AA8379AABDBC48A70C3B093B601A65C3F81B36182618AD9E270453B9417F0BCB09CE62B555309DA00603AFA780A09AEDE2CED209581DB95C83AF71581F09BE0637DC85E5C834';
wwv_flow_api.g_varchar2_table(59) := '9628DCD4BF09BDABA08C63612BAE7F0D7F7D0A3B49AD98F8501F3BC100AEDF433E3EF2C39D31CA0F23FF15D4871D445BF2282C9D8FEB9068DEA4E03E37AD9F5E8504F3D624277465D586C6C60886095EB899048E6115C079ED86146746BC2AE89CC0AA24';
wwv_flow_api.g_varchar2_table(60) := '4C21C31080E7BE33F77AB9FCE16DC2499CB741073DC10BB87FDC8AFBC7D4CDFC4390DD0439AE4B79BD01E7FF7CD516FF8567BA9045C95D870C6FF8339D0FC451FE756C8C9C1BC7EF8310C78068710D5EE30E64E212EE32CEFF0EF7A84936D3283782CEB7';
wwv_flow_api.g_varchar2_table(61) := '16E9BC6EC46098E0EA9B4817F729883B0FEB2250950209A1457112C375252D901328E6611AC37958D104D8A56512682E53B8F9CF737E989F4F465E8095EB40723989633A03496347A2B5EB8EC2F81590D14F517259750693325A3C35312FEF6AB1A3693D';
wwv_flow_api.g_varchar2_table(62) := '886AA860986036BBBA404068895CFE5413083A2D8DF9CA4B21F9DCB2D481964BF7ACE5784EC2799341075A3EE375A07ECAB44146E7639A5AEEF842EC947CC436985EAEC7176D9843A0C926EA44F8AB0F04950FA2551B086C105C9D8F931C8EE33A94CBF1';
wwv_flow_api.g_varchar2_table(63) := 'BABCAC723D5A86840543508E49EC64C1104C0FC637CAB961826B6F6EED39E686AE1A3D2664AAD131770DEB130BE7663294756F93AA135D8B42C030C14BAD7F2F0AB32595C930C14BAAEDCBA2B209C1B739CD09C109C1B520904CB26A416B6E59B31886B2';
wwv_flow_api.g_varchar2_table(64) := 'E077FBFB83B32ADC850F5ECE5DFD24760104886180E3328C17C83C3B3914C1BB7B7B5555ECBC6216F7CE7099703C1BE56A63889D8FA18FA9D01857ABA25C2ED44687EE5D793CC26FF1F915EFB6109FA709F4C1F22293EB8A08E81BD9A09998524E635C31';
wwv_flow_api.g_varchar2_table(65) := 'CF0209A10816A257A9B7AC960FB1E9782EDD91DE3D3DCCA79893B01804F8BC41A6236DCF0C3BE72CAB19983278187BE7B57F87E3828F40784F818B2FBF32F18474E5F3E98EE6AEDAAB91E4D0086447A7865DE9FEF1BF1F6AFDB18A0B60AC656A39862398';
wwv_flow_api.g_varchar2_table(66) := '25052A70E8C4CC41DCA3791C0371B774F11433EFBE276141041C4085590CC092B7F040D14F5F792C7352650A60BBA09248055891249845C010A6FF0F29BA4435A8E815B50000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72342960847797144)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/bmp.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D0000185F494441547801ED5D5B931C4576CEAAEAFB656E124208B421B03017B1B2600561B1EB352CEB6B3878F05A7AD80847F8C10F7EF486631F1CE10866';
wwv_flow_api.g_varchar2_table(7) := '1F162D01DE3F606F84C3018865F083BD76D8E10D07B0B180F15E840402049210370192469AE9EE99BE5697BF2FB3B2ABBAA747D397ECDB68522A555556E6C9CCF39D73F2E4C9EA92100692E709CB0099919298F7E6EDCD308E5626F60D8CE779169247C2';
wwv_flow_api.g_varchar2_table(8) := 'AF9EFECE039E6B3D8A9C19DCD6FB26DEDA5B93F796A8A3EF09C78A5D9E8E65FEE1EEDBFEEE43CF7BDE11E248DDB2841C8FC9E646452BD24FC361705F79E7BBDFF2EAF51F4DCD24A6C99D35E0AEC9F05B6E6565B89C26D4AE4C6B1EC9B5D6D579E1B22CD3';
wwv_flow_api.g_varchar2_table(9) := 'B8C7851713B54AF42B6F5F78EAAF2CEBC8872FBE381FF1BC7977B3801C6609D9D155F2BCC38E652DB83F7BFBAF6F722CE7A73373A97D4B8B2B55CF12B6056E938F9A9FEB37A44BB16975EDE1ACEAEB73809D2EAD4BB63E59BF6E50535DC1EC785E3D1A49';
wwv_flow_api.g_varchar2_table(10) := '14A7D373D96AA5F6AAE3D5BE4D4D26C80F3DB43940B6BB42B4A5F0C282CA8858F6AD98BFEEC82D1585025780AE0790BDA633F3D61EAAACCAD7F55ACF41BD669ADDD4D565297CBCA6EC79B0609EA8566B8599D9D483AE1579F6DDF34FDEFAF0C3F3B5975E';
wwv_flow_api.g_varchar2_table(11) := '9A7736C39CCC81F69C0E1FDE476510F5BA650B4BCEC5D43C306E120EBFABC272683096978A5E762AF160D5AB3FB39940EE0BE0858553D2F23A8E0DC525C23DCBCAE82AD6A9C3021EB467E57225776A2A71A8EAD59E39F9E1D1DB368326F705B0D660A283';
wwv_flow_api.g_varchar2_table(12) := 'B94FB9D2A383AAE396617A83040ED0A1B2A5D720AC5CBEE866A79287ACBA75ECD4C747F71264219E970210549A9CABBE000E0F934ED1A42870ABA5D1732DCE36CDB5D2E4E403F59AF52C418677EDBEF4D2F726724E3606705829C2C04FC2353598FDF4CF';
wwv_flow_api.g_varchar2_table(13) := '74C2ACE51C353971BF04F94C589327468E25EB8D013C29DADB4EE0B406879E4990A9C91264DB3AF6CED9C77F939AACCCF5E4806C0C60AE3F2735690D6EE97F18E48335DBFEF1C90F1EBF3300197EE5042463004FCE0C2CBDE62668DA68B07E2E41CE17A4';
wwv_flow_api.g_varchar2_table(14) := '261FB084732C007961221C2F63004F92FE36A91E9649EB68700364ED7865B3F103B604F9295F93C71F646300AFD50BCD9F313F77C68186266700B225DC1F9F38F3FD7B68AE17C47883DCD9F03AC2A8492F3AAA31B242BD991BB584CAD35CC7F7DB91C831';
wwv_flow_api.g_varchar2_table(15) := '827C64CC413608F0C8E0EABEE1DE653170BCB2F17B2CDB0E405E38329673B231807BE759F7F8F45DA3370DD6CD36409E9A4A4A90DF3CF7FDFD478E2CB80B00797E7EDE184F7583FD9CC7AA33FD0CA4ABBA2DD2780D2F7A3DB232B209EFBA4690B15FF1DC';
wwv_flow_api.g_varchar2_table(16) := '1BEF1FBD9720DF7DF7296B9C403606707F4AB11E1F8790BFB117DDB6137E58D34130A48660C85D4E443C7BEAFCF881DCD71B1DE191B72845F8D1F85D531A7587FB1371BCAD249CDC3234793A79672E5724C8DFDEB7E76F8F7BDE3E509EA7C986088D2EF5';
wwv_flow_api.g_varchar2_table(17) := '37BC50BF272A92A5C165FFFB61BF325B01C853C93B5DCF3AF6E6D9270E5AD67CFDB1C700F188E7646300072A11427D4C2F615E83D40F07024109819CB84358F5636F9D3D7AFF3880DCCFF002264DD815CC6A53EAC1C96AAAEFDF3440CE4E27F7E2C5A067';
wwv_flow_api.g_varchar2_table(18) := 'C601646300B7F0AC1D03C6366F83506537FD6E809CCE266E97207F345A4D360670375C18B7B28634580F4B829C87774D90F19EF87327CF3F7E6854E6DA18C013E5646928FCB3410DD6941B2067B289DBF042D0B327CF3F3912908D01BC49B70B3560BD9C';
wwv_flow_api.g_varchar2_table(19) := '1B2067B3893DC2734702B23180C38E692FDC18669D267FA1C7404787FD95201710F122C836407EE3EC0FBE4673CDFAFC3D5487747A2E66B081498238C42F831C08510D5FF28D2F8720634EDEE3D8D6B327CFFDE0EB3200F23D6CB20E186483C36BD28BF0';
wwv_flow_api.g_varchar2_table(20) := '00C7EF7AF8B22841A6E385FDE4DD50EBA71B208BC7F04AF6E034D920C013B4E53F1A596CCCC9994C0C207B12646442DC0607B23180C9B3D1F06DFC0CC4357AA440CE976BE94C62377EF0F3CC5BE79F7858813C3F104D3606F004E9EF35F83F944712E495';
wwv_flow_api.g_varchar2_table(21) := '42B99AC9246E01DF9EC606C537D452CDBC261B03983FF49CD46438D0D1091BC02C2B52C897AAD0E45D754F3C7DE2EC138F0C42938D013CB9F0CAA905E651E1C2933CF00FF31A07F3C3F7ADD7FAB93E879FFB7968493623FFE10F6D8588C0F1A226DFE438';
wwv_flow_api.g_varchar2_table(22) := 'DE3FE3076FDFA4267319F5FCF387F1B581FE9331802732920510FC44B30900D50F24C979DE371DEDF2C265F4737D6EF30C2D90A4A48B1313DB8DE6F358424193F183B7674E7D70F40FF9806F8798D86A340630FACA7E4D46D2C0D2818564E2E5397C9703';
wwv_flow_api.g_varchar2_table(23) := '3BF78E5DB72D1BBF5C1FE261A32DDB71560BE54A369BDC81CEFCD3BB1FFF5082CCB532B4BD2FC61A7BA3633290F57B0996D14C1254D7AB3905A8505D7885518F61B9902F4422CE8DF89CC40FFFE797DF7DFF91834F9E5D58380C255CC06FA27A4BC600EE';
wwv_flow_api.g_varchar2_table(24) := '4BCC7AEB7B5FB5547F31E179B578C92D3BAB2B2EBE214345E613AA78F81C6EAADDB37679E13AFA7ABD727EBE27A230282E2CC85D903E78D8E2ACFA0DB6FFAD0C4DA68BB33180BB68733C8A023F5F8BAD78221AB5B0282DAED6F0390AD8440932BBA9C4A0';
wwv_flow_api.g_varchar2_table(25) := 'B9C33A4F9FC3E5C279CDB5D49D7EAECFBA8CBA677F62D188A856DC9AA879F8E179FFC918C093E86411473215A07AD118DD1147ACAED4844790F9F633158B89FC6F73CD2C050D0B7597D6D4558460443C7ACF70BD143DFD998CEEA807A58D395993B45D18';
wwv_flow_api.g_varchar2_table(26) := '0C1F9C548CE5FAC58AC41C2B99A2325B16184D174C1D78D6EE1A7482FC2EAFD7D4F5DB901213929AF06732C2FDEEF4DA18C094C8894F1844346E0B802CF8667B63713CEC811964A63180031B366C6E186E6F5C4036342C830087EC8AA1CE8D8CCCA84136';
wwv_flow_api.g_varchar2_table(27) := 'C84A83006F1A1D567205906334D7E9119BEB3EA5DC18C0143A8382D7E7B0CC54A7874DEF7A92413606F026D3DF4042A8C9130CB23180E1E5074CD964573200019053D25CE387FECC9890640CE0CD0BAF42529BEB543A8225D4E4806C0CE0498C6475AB84';
wwv_flow_api.g_varchar2_table(28) := '6B4046C46B20C9205963006F3E17AB3D74043922CD3534D91990261B348706016ECF904D990B90E95D4B733D28900D31CE18C00685CED0D0064B66289A6C6008C60036D097C92341731D8526A70668AEFBE48A3180AF0727AB2DAF4373325EF919BB2594';
wwv_flow_api.g_varchar2_table(29) := '31802775BBB02D68DD66724E862627B1841A37908D01DC2D4F365B79B9841A4390B700362869E308B2318061A5B61238306E201B03F87A5B265D4B9AC7096463005F6BC0D7E3330D328321A374BCB6001EA0F41164AE9347E95D6F013C4080495A6B325F';
wwv_flow_api.g_varchar2_table(30) := '1AE858930D3A345B000F18E000644BBE19D211C8061D9A2D808700701864BE3420411ED45663CB788C017CDD862A5B187AADDB3A3E9E14895AF2CD102782B0E610403606F0751DAABC16AAA167FAA732C304D918C0A1716C5D6EC0012AEEB040DE027803';
wwv_flow_api.g_varchar2_table(31) := '3006F1983E5413C8584AF145BE866F358E5EB4C13E0D82A76347730DC8989309BA04B98174FFDD36A6C106FBD4FFA826848204998E5744395E3CD31133998C01BCA5C1BDC1D270BC006E1A4B28CECD26BD6B633F00DFD2E0DE00D6B518F172A8C991A870';
wwv_flow_api.g_varchar2_table(32) := '6B75E196CDA88C31807547B7CEBD7340C5AE11F1CA44452D66C6566F01DC3B1E03A92935D9C1171C92FE371CFA6CC5D81CDC673FB6AAFB1CE05447904DA531D7603DD276337CBB673A6F23F6B4A3B75E9D41D05CAF2D95DF4DEFAE4D091EFA46053A7DDE';
wwv_flow_api.g_varchar2_table(33) := '291B3AA3476A1CA6837F959151B16E95AF18C07C7CBE4CFED7659CAF182CA559DB883DA4C4F2A4A58FF5EAD8A0B6D12723353D4D733D5A686E04C918C06687A5BA55F74A305745B08540302980D535A0B46238120001912080E6D69770AEC9FBA08E2ECD';
wwv_flow_api.g_varchar2_table(34) := '3300B322781EC51907E43B109070395E634D8AB63DF441258E50F7C3CF42192984E887CDBE487AFC289D12385D6A94676300F73F080D9E03C6AECA2362CF8978F44B22EACC0AC74E81810E58EC02C8A2A8D5F3A252BB8C720509129F25A27B24A315682D';
wwv_flow_api.g_varchar2_table(35) := '22E751DB5D942FA17E1EC7B2ACE75869D449C8EB30302C1B75B6A1DDAC3F34DD3F7DAB34D7F3CAA095437F96F0C046F929790ED3F26B8CE43426009379CA14530BC9D8E9E4432293D82B12916D2262C7A5E6E11F2811E0C347E03CCF05C04BE262FEE762';
wwv_flow_api.g_varchar2_table(36) := 'A9F8B24846EF12BB661EC5793B185E8602825E8BC229E128899A5B10E5DA55B152392F56CAEF009CAB0066DAEF8302D2ABAF8AD9CC37C5B6F4BD20833F1010D53E71D28441D1AB88AA9B17E5EA25912B9E12ABD5F7508C5685A67DF49A3C06006B70C1AC';
wwv_flow_api.g_varchar2_table(37) := '7A4164E307C48EA9DF15E9F8CD521BC94C32974C9609203B96836751118B4C8B5CE9ACA8AF2EE33E22E2911968F1360056F219CC3A1A0C55DD27825C9874F7B700F24171B9F0BF225F3A8E1F76A71BF5F83C8AFB38E8498B4080F1541D9A96A6BF4B78C9';
wwv_flow_api.g_varchar2_table(38) := 'DBC54C6A9FB8947F4D5C597959B66AA19FEDDBD7F5077F1E0380B5E616C44CF210B4F0F7C1D459C4646B001CF31F34D191F32599AB99ACEAD4BDAAD466CE831400B75E01B834996540C1F9D696C087D958A7B0F033901414270950EE10A9D84EF1F9F2AC';
wwv_flow_api.g_varchar2_table(39) := 'B8B2FA22B2D328AEE9AB3E48E1F20156A0F93083BE143E5813B645E1DA39FDB0B4104BC5D7D06F9AEB760216EED160AFC700607CD217F361367140821B03B835573936364C333EBE2A562B1761022FC31C16A586459C349879033478CA07507D6D974C96';
wwv_flow_api.g_varchar2_table(40) := '0700B2ED08EA2C8952F5A2643135DEB113D0F2694C01190806E66308441D14A3CE34807908C25110CBC5D73125CC2AAE4308480F284A41AB43702E177E254DB2B21873229BFC0DD44F4B81ACB9ABF27A367D40E4CB6FCAF9DEB692A0C5EF8AB6F80483C5';
wwv_flow_api.g_varchar2_table(41) := 'B541DD18C00D13DA20BDD105253B0226AC8029DBC58EEC43D0DC39804BAF19DA654701D01571A9F00B98E1935208A4E649CD7400EE4E9189DD2E2AEE1580AC350534E55FEEADE2C3A2954FC4274BCF4980C8687ACE71D49B4DDD2B66D277A35E0C005741';
wwv_flow_api.g_varchar2_table(42) := 'BB24CDFDF6CC21D43907A073281B660DE8C1DCD2625C5D7D0D65DE41FF66807B45CC55BE21764DFF9EB40614186A34A78EA83307E1FA184321C0A34BCA161968BFFB5776D834CD65150ED57D2213DF0D4657644F086EA9BA283EB9FA13CC69FF0A8DB928';
wwv_flow_api.g_varchar2_table(43) := '358EA698A90EC6162B6701FE7F8A42F93480CA0057986FCA4C2829F3092D95A61CCE55FD0ACA9F00E84F8B2F967F2EF3B9B461AAD7AB30D537C107D8877C0A594B92E125187E2B856346024C539E2B9E104558170A946E9ED3032D469046A3BD6C3F2CA6';
wwv_flow_api.g_varchar2_table(44) := '417F067E455650238A60D414CC33FEAB5D98546A2F1943CFF452FE75B15C7A0D9A70A3CF3CD6512C64F8817FB9E6D549B2D0E7A37F92E6959ACBFFFEC2B6E210263557BA5E0EC2F15F30F33BC45CFACB5C78413C5CF4252E92B15B845D6459CEE39A926E';
wwv_flow_api.g_varchar2_table(45) := '85CD2AB3ADE678AEC3118C41311EBA7F34FFB40A417DF67B2DAD80EAE0AE8C6970775D5483A5F6D26426B0B4A1F3C344861531E7E661961D2B0BB6C08CC38CAA798C73AD2B81E59247B19B4350C0B79C643E41A569970704C2032DD22580CBC5B7000484';
wwv_flow_api.g_varchar2_table(46) := '8A96C10F00D313A7D0D5F1BC09141F40176B74FA0C5C5AB93832F1BBA43FE0C229D4E073DEAFBA8B184B2CE81BAE46918C69B0CFE22EC6C01A2A981041108340688696B0A6ACD6C920062014E3DA11E6BC8FEDF1768FFC3C25485A937CB1420DD6C11C5F';
wwv_flow_api.g_varchar2_table(47) := 'FB0273780E6BE71BD13EA70788131C26E51851A89034799EE929476EC18572D8D2B15BC5B6CC7D10888434F1F4CAB936BFBAFA6BDF3ACDA06C302EDC0C3D19035831AFD3FEB3B4E498648E5A7AD09151F9F4A2C9701BC0071C5E4B5BB5196AD9BF0CE528';
wwv_flow_api.g_varchar2_table(48) := '99D1208548B02D46B538F7069FF04771863271C8399DE5490C369E168340DE3CFBC7B8F638CBE21E5E3E40A770F2BA5ACB89CF965FC43CFF26EE19015356896446958C01DCDB00A85BCDC100A55DDD3026849E7F19CA59BF5BB210D10378A10AF23385BE';
wwv_flow_api.g_varchar2_table(49) := '4315AECC2C0A029744AA0EA70A3A768C8197C552E96DB1B8F23A3CECF741919E3369731C4DE286FBE12663737088475D8C80706A13A6184DE7859AA202F7A4DA27839A3A16D022388E9DC1F22681360220EA9893A9D9DABB46079B922B3D72986F801D7C';
wwv_flow_api.g_varchar2_table(50) := 'B3D203B09F42734FA21E1D2F6D0182F69A880CF1C69806773714724D39473577058CAA49EF5969AF05A7650E8C9F8166AC203F05F657C0B8B02C6AAEB3D550CBFE6528A78995A4AFE7633A6D89C82E1173E850C1BB96743CCCC94BF0E2F30009E697E892';
wwv_flow_api.g_varchar2_table(51) := '18D497010F19E858F915429CAB8880DD2352F15DC8AB2130924690066B61F80C170BFF21FBA4FA1B084E5347867813E6DA109B6553E49C036FF3328E82642019CAF92C89F528BD537AA92C67432B5479D6E1A1B6FC70811A8A8912728D3B1FF84946A240';
wwv_flow_api.g_varchar2_table(52) := '8154A895048EBB3FF49467535F568245806520A3060FFE738056407E8CBDD16414C0D0DEA5D5FF139FE57E243EBEFA02B4F633D041B084FE029677374CFDB6984ADC8FFA39D4236BD9D7D1A61101AC18472696DDCF1128F8C207988E0F3522216EC87E15';
wwv_flow_api.g_varchar2_table(53) := '1B0EFBA1511F43A3A8E5049281116EF915A597CD6D3F05A0CFC4167ED28432C8C1A511975A8C9A55DD0B12BC1BA7FE04EBEF3DB23D8A09012AD7AE20C4F82E883148D1C21A7F5EE6122BE6EC459FCF888BB99F61B9B40A67308673496AF28EECD710C9BA';
wwv_flow_api.g_varchar2_table(54) := '197421B42DFE85DFCBA19E5A46D17BDB81AC77428348506BE290F615B1BC7AAA11E4903A0990B901B07BF64FB15DF747601C971B8C48ADE2CC756C0211A7FD62E7D4B710AEBC0BF9082D860069F405CDD0FFA560D0EB8D627F792A7148EC9EFB73B13DF3';
wwv_flow_api.g_varchar2_table(55) := '15E4731EC5320CE05208AEAE9C4404ED03393733BF29F9C2439F8107F7AA73A55FA3CEDBB26DB6EF62EDCC5DB0EDE9AFA32A6D0B975ACD4E6413CD21DC8C680EE6C8B416A744AE7C1CA6EF76B13D7B1F9C520626A8AD42860E6FC1B2A4583D88F52536E8';
wwv_flow_api.g_varchar2_table(56) := '914F534A0DE766433492119F2DBD2CB5256C0E8905353D8DA8D4EEB9BF202980807A4E0A819539E909CB6813B45BEE5481E6959513F0825F8626D303A6DC37C484D59B6E495B0A05E6EAC59557B16FBD5BAEA5A9C5FCDF96E6D2FBE1709D8500FC02C2C2';
wwv_flow_api.g_varchar2_table(57) := '8D0B5F3A24A1E1FE630CE0EEBBCD41133068314CE717F9FF06E3B3623A753BB49A66189B00FEDC96897F4908FA3C7EA26E5063D4C63F354DC5A89557AB664E3E8BF9FBC3BA1ECF1412C6BC69DA2336C2986867B1F086F83CF7EFA05702E069A9A1121498';
wwv_flow_api.g_varchar2_table(58) := '65D25414F5194FD0750660388F9760AA170BC7E1643D02E188807659064BB6671FC4E6FF19DC733ECFA065AE16869F8C99E8DEBBEE820129CC8D97B009F02FE272FE38185D915A4A078660F25E6D18A8FD5F6A10012043E59B1B28A3EEF13FA4C0DC522B';
wwv_flow_api.g_varchar2_table(59) := '1978A0B6530FC3078195010AE4AF562E884F977E2A2E2CBF8039942F0D6870F110B5B8DC611F1CF80AEAAC5EEA93D3319FF30F347E093B4CF9D2077E9F95F73D9DDC2B7664FE00741808A1A91E8D168F5083C9449D304782B9F4A82F2C3F0F661DC00ED3';
wwv_flow_api.g_varchar2_table(60) := '3E78D33BA456AB485750965A5242ACB7082F76A57C06CCC75B176062054E12FEE74E683ED7B14A76092E592B418660507B2BF2759D8F50F7341CAB4F512721DB0F6B19DBAC218C29F7933965802EF77BD98E72EC38BB238205E1E42ED5E5023746D2E88B';
wwv_flow_api.g_varchar2_table(61) := '0A5BD2F14AC56FC254B21B343E421FAE1D95D3A3337D1E1380392C82CC987405EF58BD22E7E598B3131EEB76308D5B74D4469A57EEDF16E05D5F02C317518FA616FBC8D0C00BCBFF064632C840ED6A4E0A609A7DBCD007C74E073368669508D0D4EB5AAC';
wwv_flow_api.g_varchar2_table(62) := '9F12578BBFC43CFAB64F4F015A7397F18C5AAAFC049A6A1B61C995F27BE2C3C58B5258D84F6D016A785F8BC10F5D1E17434DC6002603FB4F9C93954924D094FC52F59C4F36603E81903163193552F32FB5AF5CFB0C02A283164A6B759F646D4E9E10083A';
wwv_flow_api.g_varchar2_table(63) := '5CC14B76044347D37469B480B235043D2ADE259457B4A44966944DD2D165290CB01670AE2AD8B7D6ED2B7E70F9C5F2BA8FBACEF0CEC600D6ECEFBFEB8AD90A68359FB5810ACD68B62B4DE23D2D00B8D94117A43EA39CD6DAF675541F18CAD489F5747B3A';
wwv_flow_api.g_varchar2_table(64) := '4FF703A2C3F7B99A48B52BAFEB0DE76C0C60E5699AE8B4E650AB56E97CCD60A523CD1CD5CFAED58F703D4D73BDF22CCB7E749ABA29DB29CDFECA190398E6CB6C6AA5A781D1ADB43ED7F91B9D7BADB711DDF17C6E6C9944F6B742309E43BEBE7A650C60EA';
wwv_flow_api.g_varchar2_table(65) := 'C5F5A51B932128C600DED2DEF104DC18C05B067A93036CDEC91A4F864D5AAF8C6970108A9F34168C577F4D4F757D01BCB070AAE1574183F97EF956EA9303E46138A610E6712FA4FB02F8F0E17D52E05CB78E401D76424D8B5F2F239AF03A8A87F8411E78';
wwv_flow_api.g_varchar2_table(66) := 'CAA1681EF73AACBE021D5ABAB079EE39F8E3EF9D52933721D44AB77A63746775C134C9436A8B8B3F6C4BF3B8B776FBFC6DD2E1C3AAD9942DCE952D717A6A26B96F6971A54E84B5D3C55EEAE185CFBD7678BD7AADEDAC574EE7775B5ED5E3087A4DEDEB06';
wwv_flow_api.g_varchar2_table(67) := 'FDC0A605B6A1C043E7EAE2EA7BE4295BD23C36DB6A87D4206ED85841B7905E79F76FFE0C7AFB8FD9E904BF85D01CF4D0C8F241BBA4C71E8CB6592A5827FC2C4CA3DFBA9AAEA62947831BDDE7D633CB85F3743D9EBBADABDBC6595FE6964BDC8FFCCBAFDE';
wwv_flow_api.g_varchar2_table(68) := 'F9F72F4892211E879BEAF45AB3A7D3F26BCA85417EF5F4771EF05CE751CCC67C4B4E4D226B6A6C65B472C0970B1B6EEA123E29FC93DFD9F7D4EB2C13E66D6B9DA1DEC331E85B5086DAE10968CC144FFF1F784191EA5BE77E630000000049454E44AE4260';
wwv_flow_api.g_varchar2_table(69) := '82';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72343314124797146)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/cdr.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001830494441547801ED9DFB8F5CE579C7DF33676E7BB5B1F1150CC6E006622780A983A085B42591DA484D7F284621B4F985A8AAF21F44AA1457299050';
wwv_flow_api.g_varchar2_table(7) := '29A92A3552437F681A4C6836115555B5416D9AC4019472336E429310301073F37DB1D77B9999734E3FDFF7CCD93933BB6BCFCE79777666BDAF76E65CDEDBF33EDFE7F6BEEF99B3C6384851643C07CD2C6B13D1FEFDB995308E56266606464CF13C13A9E1';
wwv_flow_api.g_varchar2_table(8) := 'E8E0A73FC2D527395B6BA22834B95C6B7FBD732DFA4C5436B9919366E0AA47BC3D7FF16614EDF38D190B93F1F40EB19D539209E06670EFBB1B86FD83192DAEB1E4CCB6AC138B7FE7543AAD394B18ADD6206DBD31C1E6274D187DCEDBFBF923D10FF6E7CD';
wwv_flow_api.g_varchar2_table(9) := 'EFEC0F560AC8E9D12E9A8D9278CF1B0BA2837FB2C578E17F9AB5E55D667CBA0A9E396BB4856B826F3B3DB5966FBD6EA530C9D7FDF479BA5C723F39CE961584D5D0E4D74F99D11D23A65AFB1FB23EE5DDFCF9375612C8D96CE858C2C968071CFE80393B23';
wwv_flow_api.g_varchar2_table(10) := '460B5CB53BF7A87B17FA2C542FB9DF5A377D3F7D9E2E97DC4F8ECAB3E791442E6F4750A94D98D1C15BA1FD4074F8AFAFF17E777FCDFC70BFBF127C723680F7ED925EC0B2106D4023C4B2E43BD6DDF84E4F9E43AF4D1E7E97F3B353911929DF6E82DA81E8';
wwv_flow_api.g_varchar2_table(11) := 'B98776AC1490B3013CF672CCA430A7385AE156CCB3BEFAB6329A13F5E6EC7400C8B7A1E38F4587BEB8D3826CBE4D746DB5BDAF4695109B0DE04483D55A0C71D26E6F1F63BB93A211639C43383D803C07C8A30398EBFC010BB2774F607EF89798EBFE0439';
wwv_flow_api.g_varchar2_table(12) := '1BC02916D9D37E51E084CEE428F78284F2277EC85C4B93F75A905F78E8BA5893C7FA5293DD02DC0A78BF5C7B6830B8E262A4DB0AC21273BD9733CCF5C33B3D69B211C82AD83FC91DC07D35EC1680120D6EDC6E803C8C2687C13F47CF3F787D0C727FF964';
wwv_flow_api.g_varchar2_table(13) := '7700CFF16B0D6EF5FC995D899B23A131C813F2C9E59B5995FB5603E4FE31D7EE009EC39F9E87B541E0C26657FC89CDF570E9A67E04D91DC06257BF697142AFF5C1C94503F7FA5943932DC8DEE3D14B5FDA65CDF558EF6BB23B8017E4CF1C86F5CE8D59AB';
wwv_flow_api.g_varchar2_table(14) := '337BB2106DB126CB5C0F976F6423E5F1E8F003BBBD7B08BC7A1C6477002FC49A5EBEDF24946D82AC79F25079B709F1C9B320DFD3B3532877008B3F17E5518FA1DD446F13DA0B111A9BEB04E45A02F2189ADC9B20BB03B82DFE2CC4B72EDFCF466BCECE94';
wwv_flow_api.g_varchar2_table(15) := '05F288D5E4C7A3430FDCE4DD5307990707BA3C9A0B76E78E98266DB8609FCB9FD94AEBC251F4FCB46AC54BBA3C315DC327EFB2E6FAB9876EB6207FF0654F4F87CC5FB1FB77DD1122ADC8A619DD1F7DD2E3FCF3E02477FE63BCACE9B3765D639E7C3D803F';
wwv_flow_api.g_varchar2_table(16) := '16BDD47B20BB03B8552BE6674B6FDD6D12C8A68B76E9D4A87D76A1629003403EFCF01EABC95F40DE7B4093DD01DC117FDAE5E35297CB44BC56AE1B9A1C04F8E487F67ADEFED0F400C8EE001606FDA2C5099E4DF4365D2C56A21A9A3C52DE89AB6283A237';
wwv_flow_api.g_varchar2_table(17) := '40760BF062D9B25CE55BB19CBBD9D00965B126CB5C0F97AFE30917F693971FE44B13E056F8EC5265EBCD8EAE1BE67AB8146BF2E1076F5D4E73ED0EE056ADE8883FCB54C96AB0B3BE5320A3C9018B212F3E78DB7281EC0EE0C4AF39E353171BB2D324A7FD';
wwv_flow_api.g_varchar2_table(18) := 'C520DB7972E91A8293C7960B6477003BE54F971B5BEC42477BE4C58157BC18B2DD82FCEC5FDDDE6D4D7607B086D36F5A9CD0EBCE07B742DF0079A8B4DDE47DE6C90FDE614116BBBA304F760770C2ACD621F6F2B5D86FD3EC4972C3E53106F9FC8CA2EBAB';
wwv_flow_api.g_varchar2_table(19) := '4D4074FDE297EEF4F6334F2645D1D22E6BBA03D8254BBAD556935076016499EBA1F236607D9415AF3B6290BFC013B94B0772FCD30D170C157F9694472E886C69A389DE26B45B0A3AB9546F7EBC4151DA6626660E44CF3EF8A7FC34F347208C26F364B656';
wwv_flow_api.g_varchar2_table(20) := 'BF1C27771ABCE4FC7138F279696D42DB61674D4DC5D1F5F94AD50C03729EE8FA85877E0F90A168FF9268B23B809BC6D1E31773B014E2F3A2BE140351EF79737E0690CB5BB17ADF8C0E0B6411E01E64B700778D478EF96E173AE6A0EEB8937473FA198C97';
wwv_flow_api.g_varchar2_table(21) := 'C75C57F1C95B4D00C82F3E70D75280EC0E60F1A79B3C4AF3ABD3F34420354DE2AF2971A95BF6769295BE4E9D275593A37471BEBA30C8B61497B3BF7542930572692B6BD7DF8C0E7DF9E30259BE38FAB6DE36903DB90358A45BF2B313D5FD1660AB8433FD';
wwv_flow_api.g_varchar2_table(22) := '0333E958FD332BB8E9EBD4B9CA292547959FAF2E1DD892B3E52846B542A4E87A64604B140507F0C9BF6FDBE2112017F36477005BAAF4D507A94910F5D3D75CC88718D7E7BD223EF16C773F5E2EEF9BC94AC51B1EDC60FCDC3F4687BF1283CC5C196DAF8B';
wwv_flow_api.g_varchar2_table(23) := '4F677C75374DEAACFFE5A905CB3435F100350AA7FCE98963D328EF84FB25E9450EEF9C99C8FBFEA64AB5FA95F17FFFB35FADFDC4D75F3363FB903C1EE8EB305D9A00C3AC582D78722E9A2AE5AAE7FD73934114049197E377C24D0A5E67ACCACF773FE1FB';
wwv_flow_api.g_varchar2_table(24) := '85F2D379E9F3A4AE8EBA1F9AA84038107839FF06B4FA4A6EBD66EC6FB067DF95A1A28B4AEE001685FD94A057C10E7350AF54F40BD2E673FC2C3864A9C157DE3C63B9D8102F949FCE4B9FA7BBC159986231672AD5A0165659DA7490DC012C8ECCC7150744';
wwv_flow_api.g_varchar2_table(25) := '2E55130A762CC81C8A05CF8CE8D1AAC9C0048C433FF8575E360FD806E5A93EE83244C0E27786146268C692D764B4D1D47C452ECD202BC5897A442BBBEC15F39E373CE07B80EBC168299ABDAFBC25FBA4FA006BF5D994F6A55F93D194D3DE853B80459AA4';
wwv_flow_api.g_varchar2_table(26) := 'B1CF53499A3CE0DB97F4590DEEE67896807FEE005E02E2BAC9DB745FCB0A729A1007E7EE0076404C2F35B15240760770ECB17A09A3CCB4948A5D36D7733C70E621F08B1A57690599E8599630A6AE6AF212F0D01DC0B35C597927D2E4D1419F55C4FAD4A9';
wwv_flow_api.g_varchar2_table(27) := '8F86E816E02590C09EE025E3B2F3E43E04D91DC02BD00737099740CEE393EB20877D22CCEE00D680FB64D04DC02DF222D1E43C9CEB0790DD012C462D4114B848FE2F7DF19426F703C86E015E7AF6F64C0FD264055EBD0EF22AC09D8A0C9A5CC027F73AC8';
wwv_flow_api.g_varchar2_table(28) := 'AB00770A70BD5EAF83BC0A704680557D166436FABABE417111FA5701BE0883DACD2EC827B30BE503722F45D7AB00B78BE0C5CAC927D741E611BA9ED16477005F0A53A4764056E0D5439AEC0E602D72E8B39A9A3479B9CDB53B8005ECAA16C7E2DD62AE97';
wwv_flow_api.g_varchar2_table(29) := '1364B700AF6A6F83033D02F22AC00D48DC9FA5402EB4135D2F8105740BF0AA0F9E2B248B017909F8E716E02590C0B91CEBC33B0097AF4FA1DAD2648743740BB043C2565C537590F5486E3741760BF0129898150534FCB18B21EC42750B64B700AF283496';
wwv_flow_api.g_varchar2_table(30) := '6830D2E4FA2E543740760BF0AA0F6E4F2AF8815BB740760B707BC35B2D254548815CE4E78C763184FBAE756415E0E512B714C8238339FB405FE4FC2D59FA57AAAE926BD17345572FB703CF04AACCF5C840CEEE2B677E6743CB78DD01BC1A41B7B0B6BD4B';
wwv_flow_api.g_varchar2_table(31) := 'FBF3D524F01A22BA066C976BD7EE005ED5E0F6105DA8149AAC8705F4DCB540AE55172AB8B8FBEE7EE1BFB87E574BB772400A222BA82914E6BA5CEAF8BD2B4D2DBB0378D5443731B6E30BF8E813550F940A1D3791AEE8CE44A75B5D3DCFC601298B2313DD';
wwv_flow_api.g_varchar2_table(32) := '87006BF4F3998B85EE27BC4EF23BA9AB3692FA497BC971A1FB49FE228F32D50EE31977267A91E3587C71319228847778DA649F4F4DC08223C9FB0123BD7D283DA15419718C7AB62ED7E909A7AD2739A78EAD9BB4C92D9B74DD49BFF5EACB7CE80380530C';
wwv_flow_api.g_varchar2_table(33) := '0E678C094E03C4540BDB0420E5BC2233FBD1F838AB711A220086E7F98C73DE1ABCD4D5C51BA2D83075EBD7B63EF53C7C6158A1DA49BAA07F2B2C8910A4FB5D1397B5F528D623A9C7011623156CA095D5A300503261897F2A56DA62C2FC5AAECBE451269C';
wwv_flow_api.g_varchar2_table(34) := '36B9DA39E3554E985CF55D6E01A2DE3DA9BA1286E0040ABCD98403B79AB078B9897CC0147080ED0593C6ABBE6F7295B78D573B15D7E1DB6AADDAAEBE433F4513966FA0EE6613E511A054BF1EFDE62AC752FDA2ED3D04B23B8013C1B7CC71F10573A591C1';
wwv_flow_api.g_varchar2_table(35) := '591A9B36C1E8C74C75ED5E531BDA66C2C2A8897290EE89992400F5C21A9F19533C73C8948EF1EA3FC946340118BEA95E7E9FA9AEB9D104039B00B74C5DD58BCDB217220CD4CF55C64DF9D8F74D7EFC7B60BB9E7B4439E119138C7CD454D6DD6E02F59B1F';
wwv_flow_api.g_varchar2_table(36) := 'AEF7ABBA24DBAF8444FDBE684AC7BF1BD713DD4D6EC2965E962F77005B86BA1A431D5C342ACAAF37339B3E0B93F7A0419841994831D6FAD1BA54A18D113C0F0A1BD0C673A67872C87833AFA3E93BCCF4967BA97B9305D63E8D9EAE476B91DE1F88B607A5';
wwv_flow_api.g_varchar2_table(37) := '75A670EE75933F33C9DDCBC8386B2A1BEE35D39B3E86D558A792FC25BEBD21CD112FA68DCA975B0B523C59C20A48A8B02CD06869E57B51497C7498DC012CA21AE3CE40A24688F90CCEF07EC12D66EACAFB4DE5B20FD9C6BD005F88664439012AD2136E08';
wwv_flow_api.g_varchar2_table(38) := '745E4D67B518CDAB075A339BEF313397DFCA35AFAAAB61AAD1785BAFAE790296D78FD20E59024FF5ACD53861AA97FDA199DAFA07BC1E744D5C97BED46F5C5674F0F2BBC482880EFAA6017B5F653A4E4E78D8E8DD2DC08D763B3C13832029428B7203667A';
wwv_flow_api.g_varchar2_table(39) := 'EB67D0BE1B015BE617A65A608BD69CFA53F27B67281BA09DC356BB6B4357708E16118805C37722181FB67478C134E01401B18629FD5F933FF72A65A6C1A880B91FC6FC5E65AAC3D7D03E7D876711ACEDA6B2FEB700771470A5D180495E7EF22D5318FFA9';
wwv_flow_api.g_varchar2_table(40) := 'ED9FC258974113943760FE6FA008C8D8285D5AEE18253B8ACEBE7A0C6031864F70CA5430CB3302081FE98555801340A1299D7ADE144FFCB7C9CDBCC67D2263F93AAF040023A636BC07508884B9170CED3421FE565A6D7D3500944EBD60CA6F7D8DF64F53';
wwv_flow_api.g_varchar2_table(41) := '467E58C1182CC0E7D686F7D2BE04CCC7245317B31B9B593497BEF3E78F9AC1371F31B9C9E728231F9BB45B36C553EA577E5BF515D875689EA9ED3AB90338ABD0C21CAB65F8DDB0BC1BCDDD8B92002AA63531C7A5E34F99F2BB7F0F2EF2739A96887C3E32';
wwv_flow_api.g_varchar2_table(42) := 'CDC1BBA670E609EE13E5125587F99106AFECD48797B94F1D35A67288975FDD8179CD03A88000280425FFFE9360BB8136D14C7F8DA5A5F10BB21C5A4BA43DF90CED6F211F1F4DBDD8AC4F1BFF3CA02B2A47C814E94BC07A25D5C34107E44878B32440B0FF';
wwv_flow_api.g_varchar2_table(43) := 'B282E02618D9634D5FEC136914F35838FB9A29BDF7A805D314B60306407A043368AFC931EDC9038EBF99EB0134681ACD65CE6A358AFAF2AF98D4CA7AA2E1B59F019B37118853DCC35F5B0D06305B573EB6105B06AC463C27467231ED32E1958D9F239F69';
wwv_flow_api.g_varchar2_table(44) := '558D2915426493ED7B13CD4BA0B232216ED2E5B754C04DCAAAC19AB644F2B3C3A63678355A225F5AB19A666076F1CCF330F63DFCDE550882161C5AB4C4F256810F661933EBA3ADF2DB913F4879695B40BB5798C9ABEF37C5D337E14B9F46A35FA61D08B7';
wwv_flow_api.g_varchar2_table(45) := '8B2332AD34826590F9D7B4292C6176550237217F3BB5F51398FEEDA670EA294CF60B5892F76C792B54F56997ADD0435FEE0016833B16605514C0E7016443633A64FD6B01669F068C37E0F40070241DCD275144CB12127FA3C94FFC04ADBFCDCCACBF997B';
wwv_flow_api.g_varchar2_table(46) := '0C1380E56303409BDAF2715CC02DE4FFC2144E3F6D7CF9D5489600FFCDC7AB1CB5F3E9DAD09575419B01E4380E98597F8BA98C7EC01426EEC2253C67F2670FC6D6C09A6DD124C19B8F366EB7933AE6E1FC8DBB0358ED6718973587169C11AB75965C0D16';
wwv_flow_api.g_varchar2_table(47) := '9F98AB9D8789EF735E5FD858703A5267B04C378154F9DD31AB79D5D19D00E803309AAC681C7720A0838DBF6D2A6B771324FDA6299D78020BC172A48042C88AA79E40D098836FBC9DAAB407C03660C3F746F90122F4DD46ED16CEEE6561E5DF623FEC6BBE';
wwv_flow_api.g_varchar2_table(48) := '2CAF9701A52C3CB44C6BFE72E783D56E8671E9A5EA92FEC86E0AA4814C1A6E31C9BABD60227002A8DCF42B44BE5F33E5E33F664AC5F447F3604CBF4010D0720121F3DCE92D7799A96D7F4E247C0582C1FC9B299ACA28A01B3CFA04D3A3B76D4FAAAB80CF';
wwv_flow_api.g_varchar2_table(49) := 'CEB759BD52A036B3EEC36672FBFDA6B6E62EEA222016605BBC27BEDC029C49FA241DD2322D54F0B1490D6A9A02C315C4D8604919ED7444840CC85EF598291FFDAA197AFDEBA67CE2197CF33180A1292274DB9280260AAFACFB9099DE7CB7B5185EA84591';
wwv_flow_api.g_varchar2_table(50) := '41B2074CE1E4A366F0C857CDE03BFFC1FCF9086565AA11122C8B2C428E28BF36B09939FB1F11FDEFB29623D254298BB45BCADC7CB905388306DB39A822E290E9885D5C60809ADE10E06889322C6D83670AAE12705B3A4B22E6590DAA9B4AF9554CA73FF1';
wwv_flow_api.g_varchar2_table(51) := '0C407FD90C1DF95B33F02EF3E88A34150FA5952C80528055C5B7068337D127799AF6C825F85B29FB9629BEF777D47D188DFE0E4B9A47C8A75EDD65E4D0E6DAC016163C6EA31DA26CEB87DDB2B653B8DD5121BE27BC5F3435AA88C63187F46AEC08C17C99';
wwv_flow_api.g_varchar2_table(52) := '6B01ACE837E27EE5B23DE4A3C9E139982BED9219573D0D818F9D7F028AC0529216CAA72773E53C53197F8B35DBA5B7BF68067FFD98F1674ED256BD1DF5836F0D4B57DA3E3CFAB17D0848CDB9F3DB31E993A670E21133F8C6DF98E2F8FFD541269FBA023B';
wwv_flow_api.g_varchar2_table(53) := '6455CB3087B6FD5ABA5A84D012D6DD2F71C74DCA3C16018AD9640EEB4FB04AA5050E0B0EF7D1622D075636DE47FE29CCEEEB1C65C6C9137305245328CD6FE3675D88B50B002AF0AA6F90CF9C55F4D15E5400C0C22E3615BE41A4FC12F76216D83978A295';
wwv_flow_api.g_varchar2_table(54) := 'F92B009B2952F0366D4AD86C654C330B20A55B8C37F53C3B474F02384BA0F5FA2A6385C58E01BA7A24B98DA2B30E4A3E36B70E5FF713029BDB00F57A30247AB55A5C30539BD9D921282A9EFA115AFE1A7944D6D262FC73C43E7175742F20948988C738BF';
wwv_flow_api.g_varchar2_table(55) := 'C5D4467EC3944EFE1881791AB04E5096A992345FD3B19216535818A9FB4AFD8759FBBF74AAACA469176AEB1FB3BAF57384E07B547B876244E0D66288C6114CF94E8E5A0D6B48B68DD043D6AE3DDC425D283859D6D44300CBDC625E5974F0AA6F01D20FD8';
wwv_flow_api.g_varchar2_table(56) := 'BF65635F0BFEC1543DB8299B69A636D266054BDA8715C05A2B0E8B6B59C8D8CA02C49B68D7376867803930200F5F8BCFFC28A6F91D226956AF10226DDAD7466E4008AEB5D6C1066F68BBA663FED4ABE45FC6CAD5B5CC77AF670FFA46EEBD8D393F06D068';
wwv_flow_api.g_varchar2_table(57) := '2C015630780D347CD05A9878DA051B11007F0A419069CF6BBAC4587A20F510C00937600C4F5FE4C79F34E5E2C678CB8E5524AFA6E547F9541FCDDB683F490D7B1470EC36C5735584451A17542DF033EB6FE4FE6E6B0DAC66D95DA9B8AC22613BCFC5DC17';
wwv_flow_api.g_varchar2_table(58) := 'D869F2A60E9A70CDBD260798417E0821D8C9E7BAB86F59184CB26202B593D013E6D97018FFB929BCFF1482C5932631417C4B689737B905B861AD328C4AFE0B334A60533CF12DABBDD39BEEB24F6358860938CC769CD20C44937952C3FAC104081F10F524';
wwv_flow_api.g_varchar2_table(59) := '00D320EBCFF385B81AF976F9513E198D942F2D9F780ECDFF17BAC0BC5A10C9C304E7F88981FC6CA44D7C45F532C9B67D0E9ABE0174E1FD574CF99DEFDA1530ED4CC5DA9BA62DEE7639BEDD02EC644C6A4451A9E6A91EEBBEDF6629F11536E0EF30D5911D';
wwv_flow_api.g_varchar2_table(60) := '767D588CAD873D31CF003DC7931CF97367D0A417B957E0FC672C706C891FB529E0A32D407171B5ABC0CDAF9DC6AC1E675DFA10207D1FACE837BF03737E84C7770E5A331CE829122C483C9D527DEA02B282407FE634FDBCC2DAF67FF104C99BC8A54C336D';
wwv_flow_api.g_varchar2_table(61) := 'F450720BB0130D16770432A65A7351960D73533F33A5A99FF29F39AFC4E45E8D5F8691F5858AD8144F02F07198FC6B34F33C79C36C18FCCA0C1CFD05E5F9EFE9AC50457922E0FA0285DD5EC4DFE65804C95500463B4B76FB51D32FB43BE0B19FE3FFC43A';
wwv_flow_api.g_varchar2_table(62) := 'F5E5D4DF6623EA78B1057649FBD1780F7F9E63CD5AF182DDD1B26BD162402C7A9CF444720BB0D321D541D67CD2D7E63B2B4E00E203085E989E92191E0CB53C45E3B55062E7C8646B3D9AED408160665EE55C75D4A63EAAA0A43A94F399522542A5A304CB';
wwv_flow_api.g_varchar2_table(63) := 'B0E9501B377EF53DCE938029A9ABFAB04E7589FAE3F2E932646749097959DAA8D7750BB0C6EF34250CC5E76A4EECB11160C11107D25C50B9A473F9707DC8B77BC5F8493B95B9501D819F0800A7B6AEFAC33C1BF69D67FB549E52D29F8EAAA79820E99FD3';
wwv_flow_api.g_varchar2_table(64) := 'AC494DA58797A13DB7003B226AEE7812462620B43253802A8980741E5A6569D2BDF47D956DAD335F7ED29FCAA7F3D3755BF3749D2139E6A15B80D33CC830C6F9ABA61B5F880BE9326A257DDD6E9D74EF17AB9FCE4FD7CB70EEB8C9C49165A0285575211E';
wwv_flow_api.g_varchar2_table(65) := 'A68AAC9EB6C101877C740BB063E96B83152BB388433EBA03D821512B13B5E519953B801D9A95E561C5CAECD51DC02B933F7D3F2AB700AF6AB11B8170C8C76C008FBDDCF0BC7A9EB571E566A0ABAD1893E67107FCC806F0BE5DB1ACE5C218DED4E67707B4';
wwv_flow_api.g_varchar2_table(66) := 'AC56110712ED154F95121EDB8BC57F655BE848A42BE7B3191BE8991511284D4EC85C3C4597720DF14E4AA2C74442FD709994F0B843BE6403785FBDD79A799DBDD25F9AD1D22E333E0DD8DC4FCC75FA5CC55BAFEB4DF4DCE162745E28FF42790B0D34AE13';
wwv_flow_api.g_varchar2_table(67) := 'C2431F1EFE12061EB145131E2F54EF22F713182E526CFE6CE4CC630F5CA499E8E0A7EE66CFF41133C2B3334A995AB62D5C5A5F968B0CF92C3F6334DE67BD3B0F7C470C48F3B813866486214D4074F0D31F01F24F42D65A28E3F79AD95C7C2703EACB3A21';
wwv_flow_api.g_varchar2_table(68) := '9B179E1ECFF4D89F8CFED5BBFDB167358E346F97755C2264590958819DBBE2E9FF03E2F202B47F58F1590000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72343760460797147)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/css.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D0000179B494441547801ED9D796C1CD77DC7DFCCEC2E0F911465EBB66E89BA68F848EA2B879D38419CB6809B2261DA022E82022D1A4B4ED1042D10207F84';
wwv_flow_api.g_varchar2_table(7) := '458AB608901645FB478B14890BDB925B35698C06A91D038D0D44F1A5C8925CA93E245B726449967551A278EDEE4C3FDF373BDC254551DCDDD9DDA1B8CF1ECECC9BF77EF3E6FB7DBFE3BD373B32268E14044E1C621A29A3BF3F70CD75F01C93314C4DCE28';
wwv_flow_api.g_varchar2_table(8) := 'FB5CA0384EA07A0F3C3D74A731CE83C604DD41607CD7B846FFD72CF948AE50BEDAE707416B47C69C59BEC07CB7FF43CEB1BEAD81B72B08FCE8796AD6EE3A0AAE4EF34AC8FDCC33435F708CFBDD74474B771DDB5FD5ADF274CBF9696316B6E49E49BBF96D';
wwv_flow_api.g_varchar2_table(9) := '7F774BEBDBFD3F0B52FD9F30F9EB85E4AA08EEFB777AFC179DFC034F07CB8C197D3633BFA5777460248BD00AF5AA2ABECAAA4C1B9D1C5A3CBFCD1DBE6971A6333F967B291FA47EF79F6E778E5E4F245749C42E0BAAEF0FAFC32C6FCA5ECA1A8CB564267E';
wwv_flow_api.g_varchar2_table(10) := '43791D1318EBA2F2D9DC60EBFCD45D9E937BE291FDC1DAFE4F3AB9FEE78C773DF8E4AA08EEEDEBB3BED7731C5902F962FBD71EEB28C1DB784B8DF1E894CEC840CE643A531F09FCDC130F1F185927923F711D905C15C10777ED128926EF11B2A0C296604B';
wwv_flow_api.g_varchar2_table(11) := 'B972939D8ACDB4471687D18BB97C4B57EA1ED7F776FCF1AB233DCF41729FACD12C8EAEAB2238D2E0029598BC226CC9A637342D511B6975E0B8AEE22A67F49225F9AE94E33D219277394E7E366B725504470015F756A18BA7093E9AD415C38687F183CC75';
wwv_flow_api.g_varchar2_table(12) := 'BEA533758748DE7630D8309B3539668213CCE8B44D0BC7F141389E7709251C6BAE21D9C9E6766CDF37B2519A3C1BCDF59C2578A2ADB962260E7B1D929CE948DD1118EFC947F68C6E9E8D24CF59822798E8C24CDC2425B7248FE1935B3B53B7072977E723';
wwv_flow_api.g_varchar2_table(13) := '07825947F29C257882065F3D4A2E6A7267EA368650B38EE4394BB0D5E0488DA7D6600DFC94C63519732D929FDCBE2FE8B5E67A57F2875031131C2136C9D825F574821A4FD1485D8F4866642573CD64C8AD8EC93DF927FB839B354DDB07C9C1D52DC01442';
wwv_flow_api.g_varchar2_table(14) := 'EB9B1533C1D742ACBE0F37DDDD66DCD262C15093990C4977A66EF683DCCE2FEF1FB5247F31C124C74CF0749026EB5A85B6A6487247EA66377076469A9C5492E72CC145C52CBBE385819766BC3AD237E7FDECBF6D7B75EC36996B916C5F1C285B64ED2ACC';
wwv_flow_api.g_varchar2_table(15) := '5982276870F93ED44E868C0DE6722D5DE9AD4C8CECFCF2BEB1DB45F2C1ADC64912C931133C01B6DA75CBB8255F2D8A9EFE3E2E4FEB31779D6BE94C6FF68CD9F19502C9E69BC62485E49809AEC2F04D0F6622AFF2B49AE31C27993788763CFCCBB10FF73B';
wwv_flow_api.g_varchar2_table(16) := '8E9F1492632678966A70A5DD87D5B371922FE6721934D9F1CC4E7CF21D4921396682678F06C7D252BDE01091EC186F0C925B3BD33DE4EE480AC931135CA92AD4BFDE045B537E90556CB025D9AE2FB39A8CB9962677A53710853D910492E72CC1458638AA';
wwv_flow_api.g_varchar2_table(17) := '2CC82A8A2898037696646972BA23D5E338AE7CF2DD8D34D77396E002272149D5687091663BAD394E32D175A6C3DBE07AEE8EED7BB3F7348AE4394BF004135DAD0647244FD6E490E4B5811BECD87EA03124CF5982234EEC3E2E0D2E113AAEC99A0CE948AF';
wwv_flow_api.g_varchar2_table(18) := '09FC80C02BFB917A6BF2DC263852E3B834B88460AD4259921927DB192F48E6ADC49D98EB7B2DC994ADC76448CC044788953E69828F0B26B5262D2C35D705921927AF6205F9094B723F9321A4FE801FBDD530C52CBC9688C58B423D5BCABDEC8C17EBC904';
wwv_flow_api.g_varchar2_table(19) := '5EA915BC6AFF7844F23709CD6A4972CC04C74B422DA5D5DBD6589235192292DBBD95BC26F0F8C37BB3F7F1A390A0BF8624CF5982EBA9C1514715C9FCE78D5DCE6533F3D22B79D77EC723FBB3F79B1A923C67099EA0C1134E223A6AB657DF4A8524A79613';
wwv_flow_api.g_varchar2_table(20) := 'C03F564B926326B8BE48C547C115EF45C7277A6A4945923B3C4BF2F6FDD94FD542936326B811866F6A0467945BEC8F41E1E53A3B1B658FF53BABB236EE78ADF292AE7BDA7236F04A3184C25C43B26F1EDBB62FFB194B32CB8DFAEDF58C9EE11A856226B8';
wwv_flow_api.g_varchar2_table(21) := '88D835EE9BB4CBF28D023EDCEB588B08656D33A813FAE0825C9DD8BBA6ED38B933B58C50FBF16DFBB39F15387A3B248E7172CC040B99D9908A1D115003CF757CBD83E379AEEFB8AC17D475E3D53DCFF17243FE183F5D5DC46FAD1FFDEAEB8125B95F63E5';
wwv_flow_api.g_varchar2_table(22) := '2A67D9AAFF08CB6CE0F38A36AA23F25342C2D8D15CE09D3B7779C4187FD02EDFABAC4CA8B4D7DA53654429CA8B3AB23A4A499EADA7B2515E546F721ED7A37B94EECF39835E2ABD243B3AFAB79FFBC9FB6FFDE837961CD17BD77C47215F2AA99CE3394A70';
wwv_flow_api.g_varchar2_table(23) := '0891BEE1309A372DA746F077438381EFE71996CAA81535BC1C30AB2B0BE94E90E697CA79D775B6206B05DB91DE3E13841FCAA84CFA1C2638D4329CAEE365DAD2FC74D438C38370CB0CA225B93240ABAAE56355321993CF8DE51C7E235395AC42E5394CB0';
wwv_flow_api.g_varchar2_table(24) := '10884CA91F38E9160B493002C93E16B1019A8CF9E0D35DBE275D66A86CDB137D26C39E54F027E620AB821634BC0A58CAF912CC40B2E3B476A0CAAEC367D264C1EBBA11EFA9C785A9A07A933E93115D9DF1BE49702954043CD264A7AD93DF14028D02A07A';
wwv_flow_api.g_varchar2_table(25) := 'A61ADC2E66826BD0C27A02AC7B359AE4E87963F1C0E107CB229131EC8B162606618D13D128924BE18B293A8A59831BC749EC776E14C9313F4893E0E900AD37C935F0704D82A72358D7EA4972A989BE56BB66783D66826BD00567F820352D562F926B005F';
wwv_flow_api.g_varchar2_table(26) := 'CC04D7A00BD694B93284D783E41AC01733C135E882657050F3A2B526B906F0C54C700DBA60CD592BF3061348664D5E73D771A552F892390E8EEB49132E6702C90C58398F3D35C7C1B1435A9E404B72A630AD199326D7A09FC46CA2CBC368D6979E40728D';
wwv_flow_api.g_varchar2_table(27) := '34B94A909A04570960384E2E68B257A52697FAE06ADB55A8DF24380E20234D6ED52A9434B9C2C0AB69A2E360A346322292ED526372CC755383E3E43B22B91D4DAED65C378749713213A32C919CCA18579AEC355E939B1A1C23B7E3A220D98C935C61E045';
wwv_flow_api.g_varchar2_table(28) := 'DF882335098E03C5A9644C2079868157338A9E0AC904E7554272CC8FD3D4E09801BD42DC38C95D059F3CCD10AA394CBA02BED99161494E1378CD80E4989FA8A9C131037A5571E32447D1F5349A7C5521E55F68125C3E6695D79860AEF997A927CF789506';
wwv_flow_api.g_varchar2_table(29) := '59CD7170E53837B4E6044D9E4472A90F6E0E931A4A53753797E6A6E49365AE4B486E6A7075B826A7364C4EA7C96A685383934357C52DB982E4121BDDF4C115C39AAC8A25E6DAB1E6BA4072538393C553E5AD91B90E7DB27ED5E8E09BE37CC72BA67E52F9';
wwv_flow_api.g_varchar2_table(30) := 'E3356B0A8102C9AC3E392902AF3CF63937160B344D826381310E2113032F3FDB24380E549327432E58AFFDB4859F94A8B681CD99AC6A11AC497DB19C8D45F2AC31D1D10002433621295F9BF2275F53C1A89E8E4BAF4F951FC95259A5ABC90CAF16FF565A';
wwv_flow_api.g_varchar2_table(31) := 'AF28A17647892758E0C9CCB480B6F69AA22F2547792242FD3D5772213A4C713153A8533ABDAF3AAAAB72A385C2ADBA079B86A7FA0E5A9E7D748D62572455930C5B8FBDCE554FED18D349025262098EC013B1594E8E13589E8121FB1D1ACEA3EB22AD9D32';
wwv_flow_api.g_varchar2_table(32) := '4B41BA9D4DF9DAF4602277900247F82AD210999CDA0EA2BD36955B401DD5D5BCC261FE8C90A97B0EB35F42FE62DEB829AD47319B5497CBB613A8DE053244B4EA2DE6C292ABD40B6BD7EF6F2209167869C09226BD896A4A3BEF6A0DCC9A56636EC804661E';
wwv_flow_api.g_varchar2_table(33) := 'AD16E8C39077918BA7471DF30EDB28E7225575C7387E8D6B2B29FBA98EC02C6B094C1743CC16C0E77B63E632A45FC83AE6381F313C3CE658426E69D77793C2EB92738132EF724D792253ED8A92CEA5A9690E3E4EDBE6B1D7B93E7235C4BD8FD19EE8BCB4';
wwv_flow_api.g_varchar2_table(34) := '5E54BF5EFBC4112C30A4419700E95D00FEADAEC0DCB7D037EBE7FB660124A5D18CC297C2ACF6642997E3935607CF39E67BEF7AE65CCEB11A7F1141DB17F9E66EB695F302C3B7EC4C0A12AC09E61E795B8F4E42F9678E7B66F705C7FCFEDABC593ECF3743';
wwv_flow_api.g_varchar2_table(35) := '10DF960ACC8921D7FCC35B9E393442070029995D91AD366638388AE67EBE33300FADCFD179F459C4B0DE8BEF7BE63BC73C437FB2E5648154AF112951040B38917B1662A5417FB12A6F3EBE346F16B6F1893FCEF91E1DDF272BC224ED9146B6A77DC876CD';
wwv_flow_api.g_varchar2_table(36) := 'A293C6EC4123B7E074BFBE82BACBF3A613E02557DF35B320DB3F64504F690984DE72D931DF3A95325FE1BE8BD0E211544FB2DB33BED9D2E19ADDC38E598C1055D1EDB5977F1E66DF4BC75BD3A58FC28AC4C05E3F338A4B41562FE8AA5C744B8AD73D151E';
wwv_flow_api.g_varchar2_table(37) := 'B3EEF7BDE286E0607BBBCC621BADFAFABA9C79704DDE2C06F02CE40CA355D2BA94A7AFC4869BC7DEA36C8EFC31EA09CCA31C3FB42C6F3EBD322477040DE5CB8F36F811397C7C14792151425E32D503DEC79CEF39EB9AF368AB2CC2454C738A6F0D6FC182';
wwv_flow_api.g_varchar2_table(38) := 'C8C72BD8C278D8CE22173040BDCDA8E81ACCBF4CFE20E5F374C0772FBAE6E7E75CD341597552896F644A8406838F0D8AE4432F73FC35692EDAA7884AE652A6552656A0BF03801F40827CAC7C71373E7905B37B2D1C5FA2CAEFD021EE59E2A3D981B94C5D';
wwv_flow_api.g_varchar2_table(39) := '69A2D2FF61C2FFF7BC6BF304FC3CE4AD809C2D0B7CFB513BA9E56B971CF3EBF8CE9B3AB008902C57B0A613F790F1CC293A40AB64D158EDCE72FF3B30FDCBB000F6DFCC2193CF4C9B77075DF33A32149C29706B744A04C1E0687BFB2110D986CFFC281A28';
wwv_flow_api.g_varchar2_table(40) := '1087214C04C93CBF76C6333F39E19A5701F09CB410A0DBC8EF02C83B216105C49EC707DE87C9EC847469A1862C29883E40DDBFC197FE0FC02F218F0F43DB88771975EFC7BC76688F597F61C831C72079F9BCF09E92B104B95BD9DE3CEF981B680B456DF0';
wwv_flow_api.g_varchar2_table(41) := '24F3BC19FFBB80C06F8C726AE71096E2D0806BCDF3879017F96C8A362C359C60696FE477B760F2EE5B129AD648736586F79C86A0C329F30AD3B31B4158E515E4284A7D0FCD7A14D3BAEC3C41195AF539C815B192CBCEFE39890F7D0AF23ECDEC5F37F565';
wwv_flow_api.g_varchar2_table(42) := '6E65CE15C8FD10ADEE829CE5E4BF4C071341B711D4B5E00A44B0347D2B1DE807E73D1BCD6B283440075B41F91EF233B44FEE2343B9E374BE7D171DB39032882CB641ED6850523B1A9ED4080525F7A04DABD00AF9321194016481F63D22D2D720F73E085A';
wwv_flow_api.g_varchar2_table(43) := '04B01A92C84F4B7B6FA28BCA178A388D454720250C78428003CE6F87B0BF5AEA9B43DCE36D3A845C81ACC28DD4D940DDF9C89239ED61BF1782CEE002E4DBE55B65A6D7E38797739F11EAD9E113F91B89E865E295A20E25F7B15711377265619290788CC6';
wwv_flow_api.g_varchar2_table(44) := '2635C09A3280ECC1A77558F31A022B80F7A39DCFA37DB7418400D6D857E069533D4D4C68AF806829328E12115F864469BE8896962F6AF3CD977A72E69F37E4CDBD74A0B3E489E88BC8E27F6B76254FC4BC88B6CB4CEBDEEA040AC23474EA25929769B79A';
wwv_flow_api.g_varchar2_table(45) := 'CF7E2B6DBD91BC2C6E21CDBD14641D1CA073505E9D4F1D86EA0D4F3113CC939791545A1A2293B914706F60C2201C0E85BEF3323EEDED41822CCA295FA0692FE04A374E21DE316B90F11CE50F9CF52C412D9C8BA83148D024C7276FCA993FDB9A35DFDE98';
wwv_flow_api.g_varchar2_table(46) := '337D37F896B0D308952CB545A6FF24041DBAE0DAF1B1823B99E92E2C472F1D430B78EA60DDE46F44AB355656042F6D7F9F4EF8AAFC37C79295944473E24C82AABCA406886081D60109166CCEF5AFA00C03FE59F937CA4C2759D7C0D9063A1AD2FC2B1317';
wwv_flow_api.g_varchar2_table(47) := 'F2DB0A6FE54BD589343492B67523EC6EC6D6DB36E7CCB736E4AC669EC07453DAFECB179B68C72B1075064D56542CB2A4A19B701F9AD69486AEC7DF2ABAD67DAD96E352DEBEE49A5730CF8A9E93105CD1349B846F8CA9B2BE2B72A4A532B34AD15F99585D';
wwv_flow_api.g_varchar2_table(48) := '1390D74A2A23606F00E013A8DA5F1394FDF868CA7C0051FCD380966891A1E195C6C5EDDCF05E86625FDB94331FC3DC8A64C9905FFE05758ECA4C732E8034B9227FDB83DFDD4B3999673B3EA7C3284A1FE47E079909BBCCFD6505542F2929668205517949';
wwv_flow_api.g_varchar2_table(49) := '644A7B64FEC6D00425FD15B9AD90D08D19C45DCEC8ECA95E44F208447C83E0ECDB87D2E6D9E329F32B8235012F8DD60DA4D1A310BDB1DB370F31A1B2947B293A96FF94AF3D5030D332BF0AFAE43EB628A8A2DE26CC75075A6C8330AE9FC23CEFC135AC56';
wwv_flow_api.g_varchar2_table(50) := '59EE91A444931A9B2CE8007E1E6406C524C9FA5B4095C95ECD18D4120CB66A2CBBF1A4E3688B1E449D45042AD2DE0C69BF20E8DA76C433FD0753E647EF78E6C465777C4E5A01937CEC3AC6CEF733E1A1285B9DA407212F134D7F0071D64C53AE958E2662';
wwv_flow_api.g_varchar2_table(51) := '1575AF672FB3AFB2AA7F84E8F945C6D8D2FE2499674111E1A2E3BA2701242D90593B05D332A7024C045BEDC0B4DE7A2373C5F8CD63F8E34E5AAB6942355A1BFCD9090B4D78882CFEB7CB829AD1D2704624ACA0D0AF41CA5108F8031623FEFE8D94390679';
wwv_flow_api.g_varchar2_table(52) := 'D24C0D6F14252B1853472296B2F18026345EA0BCFCAAE6BF554EC25732C3F5DBF3033BF9A199AE14F52E617A0E103DC3BFBDA7DA90A4249C1A9AA4C1224D81D421001D0030F93599680545EB8856FF6855CE4E273EC724BE96E244A6360567BF82F817A8';
wwv_flow_api.g_varchar2_table(53) := 'A3D523F1B00CD3D905A97BC8D3BCB692C85E05C95F60D6E91F9991FAD9A930CA5647A29AADA7450B7534C9557911B69FB243C8574709CD346375C6D49AFC5007946F3F8996BF4CBB15C1533471A9E1040B1101B31A809E27B07913DF278D11F8029B9DF9';
wwv_flow_api.g_varchar2_table(54) := 'D832DF7C8771EC97BAC3C5050D65DE632368B5130EDF6012E3ABABF3CC1507A6173FF9E744C77FBAD83728A139807DDF0DD93FA7733CC54AD387E9496BD144C95527D25E640DD208054936E2264F84BD0471A7A3689A6B1A16DDC2F04AA0A97DB2368799';
wwv_flow_api.g_varchar2_table(55) := 'F95207D3448BC6DC9297A4242BD7D0244034C9C0AA9C5DD1F9F109CFACD5CC51BB6F340E5630A4F1E8DD90D8434074121F3A5CF0D53291F3991859894F3C0F9B3B99AB16F8B72ECCDB45848FD2598EE3834FD113345E5560B419D9BD90A4A40EA4F5E54B';
wwv_flow_api.g_varchar2_table(56) := 'C83B423994DC067C6A8FDCC15E8813816B90AF244BB388485AF5E49B2F70CF57B9AEA9493D874A699FA4D470820586405170B286D6FC37FEF1A6A39EF9BDF5CC1411B96AB92F8BA995C6DC88895DD496B74046206A9D57E3D433EC05B0B451131B0AD06E';
wwv_flow_api.g_varchar2_table(57) := 'C19CF6DEA8F3505BD551E46FE577259345223BE375E89C679EA5336CE2FE22574956843507B38FE1CF3D4B591BE69A644BEB95B43B4164FE12D1F32AE424517BD54E75F81853E1E92B90289DD2B61A20BFFF816B1E7D33658EA01D9A726C47F3E497C375';
wwv_flow_api.g_varchar2_table(58) := '5FB41102A34D802B60D2A6FA22266D2737F09364A4A0621EA655DAAB2192F2A47D92A989905FF2F6C5F7194E697E3A9A6254F345A666A55E9499C6CF2A8A6EA5BE568DDAE5A0496F125CED46FBA5ED05776FF393F40738E34CD2C5CA926A0A243568251A';
wwv_flow_api.g_varchar2_table(59) := 'F11873D0AF03EC67593ED49AED22E67DA3992E4BA4CA83B3CCEB0548D09CF520C4BFCE82F2F3EFA54C0F439F2ECC773B1153D42A91AF3A9A373E33CCD223759EA23369B17F31372E1DE2E81E22FC18D754AE03DFADBA223E83A3BE804F7F05ADDF8A4C95';
wwv_flow_api.g_varchar2_table(60) := '4D6A8A99609EBE8A24221470C1AF594FCBF42ED42B0C6D369EC27CB6B1180061ADBA28A240555399A798CA3C4CB9F7395E0021EF41DE5F32DE5D9B71CD3AC63D0BA5B9C8F2D05645C243107692326F51E730C78BA86317E769BAEE1FA5E849B48CF89F68';
wwv_flow_api.g_varchar2_table(61) := 'F96E9615755D1643EE42D1FC29E468822432EB51DD24ED6326B8FA471388D26401AC253A69D569FCF0E101A26620860F0B746412DB39EF24733E15754D431DEDF556E341A266D5914CE5459A16D55127B25173C426654A93B23564D20C9756A99424479A';
wwv_flow_api.g_varchar2_table(62) := 'AC75E1F9EA6C094F31131C8250ED334B8AC0D53857186A0D78219BB447F9DA54C66EFCD15EA047A4EBD51ABD23BD5865A7A8230D545260546A96C3DC897FD52944A65EBF2D4D6A83EA6B9FE434A9D9D53635DEC7B5C4D12491A7E3022FB691BA93BD1B7F';
wwv_flow_api.g_varchar2_table(63) := 'ECBEE47A6432A7AAA3CA113193AFEBDAE4A43222599D6D722A6DCFE46B49398F99E0F81FB954E214185B1C4BCB28A3F47CA675AE4548A9CC6B954DD275B99418D3D5E08CF1164D5165211033C1B3B59F9785D9AC2A1C33C1B3EAD9E744639B045FE73437';
wwv_flow_api.g_varchar2_table(64) := '096E125C0E02CD20AB1CB4A62E1B2F865569F0C15DBB4AA3AAF0270553B7BA993B530434615EC2F1248C672A65BC5C5504F7F6F5D9A67879B58AE1A7A68D4A291FBF4DF360460808BB0286054C4D84F18CEA4F51A8AA898EA877F96ECA7702E687C27941';
wwv_flow_api.g_varchar2_table(65) := 'FD4CBEA40F4E71D766D6D408E8356C6108CDF9203C88309EBAC2B573AB22D8983E7B0727187B8769F837D29DE9DED101BD8ED64C9520C062979FE94C7B6303FE1BAEDBFA762823C4B81279AA531D17817DE5D076B9079E1EFD3C0BE8FF92EE68E9AEB431';
wwv_flow_api.g_varchar2_table(66) := 'CD7A2C3D5E1A19089CE00F7FFA40FB7F583C4A30AE049FEA08D61D4B1AF0C0D34377D2671E24B39BE5D7C22FAB2B69D6DCAAE3F39A09510CF1907301DBFC5F3FFDCDF6972C0225D836161135A499E24520264CFF1F84BAA30859208E650000000049454E';
wwv_flow_api.g_varchar2_table(67) := '44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72344100805797148)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/csv.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000019DE494441547801ED9D79B01C477DC77B6676DFBE4387ADC3C2B2651D96B0A4279FE0933818086027C449194B24247F50A95425842255896D2055A9';
wwv_flow_api.g_varchar2_table(7) := 'B252954AF2478EAA5402A120A91460D9E8093049088EA10AC70EC680C132B68C8D2DEBB0751FD6F1EE9D239F6FCFCEBE7DAB776FEFBEB7D276D5BC99E9E9FEF5AF7FDFDFEFD7BFEE9E9D678C839424C67340665649245BB7FA8969FE7E540BB1666004AE';
wwv_flow_api.g_varchar2_table(8) := 'E7196463CCF0E73E745364A2BB13CFBBC8C449ECFBD5CDCD957B184B12388CDB4DDBFCE366D1155FE8F8F0DFED4BB66F0ECCE69E38EBCF5CE1B6163E6A02B812DCFE7FB9EB5E2F315F6CEF6C5B6819AA89722D5D9A6A5D184C8AC6E4169BB06DD9636152';
wwv_flow_api.g_varchar2_table(9) := 'F8A38E2D7FB9074BCE9907B746E70BC835C1208DF7B6F444C9E73F78E95092FB4E615EBE7BF0EC1052F3E6ACED8EC00F847131F6DB970CB42D5E393F2C863FCC85C16F79BFFD377B93EF01F21DE707C83501D1D3938A6B20F6D7E0F0AE2AF6816D0AAEE8';
wwv_flow_api.g_varchar2_table(10) := 'CEF123F1187173EA41588C7A73F33B6E0E73E143C9F6FB577BEFD91A9A27B606E7436C5113C09BBBBBEDD8EBC5565898844D3A35C191B16B027CB517F60E24B9CEF6DB42CF1B01F92F9A1FE49A00EED9B5CB629AF88CBE925209E114E7E6F89B98588CFA';
wwv_flow_api.g_varchar2_table(11) := '84895ED83F18E5BA0AB786BEB72DD9FE99B5DE562CB967BBDFCC965C13C0990597A0B4283707AC955C2202CF4B7C9FA9002A1AF60D4558F22DA11F6D1BDCF1C03A6FCB96E88926B6E49A00AE1493AE9BD080D32E80AC267A7820C903900700B97023BE1B';
wwv_flow_api.g_varchar2_table(12) := '77FD99B5EF69624B760A702AADE6FBCB44BEB4548333B6C16166C9851B433362C9A66773D3B9EB16C0209A942CB842354B968CBBEEC29263F3C8D08EFBD66B4AD86C20B70006D5110BAE80389DE6117801F2BCC20D7EE23F9C3421C82D80330B1E856DF9';
wwv_flow_api.g_varchar2_table(13) := '66C4923B0BD7854D08720B60B0B4165CC6F49C8B14645932201763EF91A1EDF76D6C1677ED1460BBEA718E7C9A246362E6CB20E7BBDAAFF58DFFD5E4EBF76F1A0199287C8E26A700CFD95E4E45F893335F0699C06B53187B0F0F9541DE42743D3741760A';
wwv_flow_api.g_varchar2_table(14) := 'F054E4D8E4654A20B3E2D551D8E487731FE416C0D3D73864C63C395DD6DCE445DE23C9D73F7DADDC754FCF167F2B2F0E4C9F64FD6ACC2966EAD7CD89298F310F9EB8025328866C9F295498EF2A7417A3E891E11D7F7AFD16407E70E32E4F6F874C46A051';
wwv_flow_api.g_varchar2_table(15) := 'CF9D3232719CD2A82E4DBF9D71E6C1131262AF91513B0958BB06E4F6F526F1B709646BC9730864A7004F1EA74C28B3267C3806C88F3C70832CD93C08FC73C0929D02DCAC166C356B06CCA7552A40EE6C5FEFE5BC8787BF76DF8D9EB7D5EE43CE36C84E01';
wwv_flow_api.g_varchar2_table(16) := '6E6A0B9E01F3AA320A64C6E45C67DBDB4DEC6D1B7E0490B702F283B36BC94E016E421F9B1AEFB99B0D53EECA885E8CB2E4B55EE03F64419E654B6E010C943309B2C6D68012C8D6920BEB4C8025EFB8FF666BC954980D77DD02588277BA0A350272BEB37D';
wwv_flow_api.g_varchar2_table(17) := 'AD9F780F17B7DF7FEB6C81DC0238B3E0B14D7286B92320079D85D5BC4DB06DB6406E01ECDC82339D180199C59055029957721B6EC92D80C1C38EC133982665508E7F1E0D323F9778B8D8F3C0ED8D74D74E01AE8B8CC6975E933C19011977BD92BB878A5F';
wwv_flow_api.g_varchar2_table(18) := 'BDEF971B05B27DB3DF95A446A60CAE283690CEC8A4B60E8D8E80CC4B032BA281A1AF60C9BFE36DDEFA94023C0CC3CF0077DDB853805D33777ED1AB00B9A36D45B17FF8A1E2D73EFDBB0C0F4FEA5DCEC46CAD0BC84E5DF4F905483D7A5302796038CC77B6';
wwv_flow_api.g_varchar2_table(19) := 'AD3071ACE8FABDE426FCA231A9C73CB905708663C3028832C845DCF56558F0978B5FAF003971BBD5E814E086C92803C5D1D92E7434348000647ED9C87E7291C06B392F0D7CB9D8F3A9F7594B3658B243909D02DC50193902D7E8C767FA65439576EA76D2';
wwv_flow_api.g_varchar2_table(20) := '83025919B1935D8F7706543DCAFE20AE2417F60D16838EB6E53CFA5271FBA7DE2F90B513B55D5F1B70909C026CB977C054634920022D554ADCA51FB0A87D29EBA40705B23253A903B22A9EFED1855E1AF0BC7CC8986C2DD94BBE52DCFEC09D7AA23D6517';
wwv_flow_api.g_varchar2_table(21) := '63B253802DF7E26E8EA7518A682D26E0BB1CBC0CEB73F6593D6EE0E1DBB6BC201E2C0E075DED97B00BF5EFC937FFDC82ACA953A5D2CD44AC17E434498A289FEC036A120E067D678F0DF21BF6DE9207B52E342D335AA4595EA6C85294CABC4C71B2BCCADA';
wwv_flow_api.g_varchar2_table(22) := '9579D9F5A83395BDD3A6379F0B960D0D17FFFEC83F7EE4D5657FFCD5DDFA2D9431BC2132C37441029CC90A888D89060AC9506FD03B64920857CDCF842DC05999469D4B60E739B3A2E96FE04B1897D3F66EF392BEA250FA56C60C98B960011EB11ECFEBC8';
wwv_flow_api.g_varchar2_table(23) := 'E7F28AB37A87F9BD3FE214C8A350AEBCCFAEC73B57839095537E763DCE591EA02DF0CD701885711486D5A466727FC1022C616572268E4E0A39DD190B72540259022FA7F4717A9B5D8F772E572A5D64E5749B5D8F71262B66D00DB4FB91CBA7D0649FC9A8';
wwv_flow_api.g_varchar2_table(24) := '2639D57BA741D6541B9D4BE5AC9C896E15CC1402CF9B872D23142F8E8142516F038FB102AAAACF644C5B74173CC0951293C5CA92E717F89603C823F0C6A7CCB21DB5EC14E0D99087233994C95890835904D9B1109D02EC58F9CA426FF4C5AC82EC58884E';
wwv_flow_api.g_varchar2_table(25) := '016E3410F56C6F14C8486956DCB5830EB6009E40886590DB18931B05F25C76D113C8AA691FCD0AC80EA5E5D4821D2B9FC36ED646AA9941760AB0E3F8A036541CD76E18C88E85E814E0F3D582335D190532406859D379724CD329C08E95CFB9EC5C102C83';
wwv_flow_api.g_varchar2_table(26) := 'CC62480EE9398FAE1D0BD129C02E04D80C34CA20135DB337E01E64874268013C43610AE436AD78954076E6AEE7B28B9EA1AC9AB65A25C87571D70E24D3B2E01A855809B2DCB5334BAE91AFAC7A0BE04C12359C2B419625D704722BC8AA01893A56AD06D9';
wwv_flow_api.g_varchar2_table(27) := '79743D43DE5B163C43C18D55AD12E419BB6B1171985A003B14A64895419EE93CB9E5A21D2352077216645E09D19B21B33D4F6E59701D0016C96A906B0ABC6AE0B105700DC29BAC6A25C83547D7933536CEF316C0E308C655F608C8BE5DBB6EB425B70076';
wwv_flow_api.g_varchar2_table(28) := '85E4047452908D5950683CC82D802700C6E523819C47DAF31B0C720B6097284E42ABD29205F698EE5A851CA616C00E8539155295963C26C8AD79F054C438B7CBE843D2A9BBF6EC799425B72C786E833715EE64A4A9256B31C41F0D72CB82A722C2E62853';
wwv_flow_api.g_varchar2_table(29) := 'EDAEEBB141D11A8367591746DCB52C991F33B65CF42C23E2B87979E411903526671F9270D350CB82DDC8B1262A19C85ACED4068502B0B05813C972E50BFA17FE6529CC818B91C00B90DBF88C43CE8DAF6E013C07C0AD6641964C70ED243922E384971691';
wwv_flow_api.g_varchar2_table(30) := '920464BB8E3CB499250BA60B93868B382DF9ADF2574B4ABD3FE734112D4B801A95EE4E74B3FC73888D6458FE2AEAA98EBDADC853694B6B3C7A94ADEEE784E5479A7775353B00FB6D08264F1FAA8455D9AB44DFBE517CC937C0121D5C8E058CDF4EBE3EEB';
wwv_flow_api.g_varchar2_table(31) := '3806AD4CB8E57A02099AF160654B55D7A283630B0AA3E95A5EA85FA655AA16636B89ECAD1A64E8A88F81FA9925B54FD978988CEAF25919B7E75900988E0D1D01B763F444C0A8A3D5E090EF7772CCA708E7001055C60A4665558743C00FEE85D6196ED595';
wwv_flow_api.g_varchar2_table(32) := '8C8E9E03A407482A63F4C9298D469C3D68162E2DDD67E5B92D27CA09CCC17DD03D5DA22B5AF0900818AE2D2D9D49F9E5C6E416F04C6DA85D25E88A9FF02CBEF6CD344B7D4D50AC60093F89589696293DA9E7A9F10023F064E1263AB9900E8F2560F26240';
wwv_flow_api.g_varchar2_table(33) := '097B8D37741441BFC1710221AE28098667D6A239FB79932CBA9567288105321370263281A03C1D123AE08583C6EBDDC3AD40AB2EAF62CAE7138717DF0478F346E85A32884B16AB245AF0EFF51F426151567912791BDB1660460328D262F8BB3E6D47747D';
wwv_flow_api.g_varchar2_table(34) := 'F2D5FED9DDD455D131DA27DB656A1CC012488C9627FD26DA748F89565C6F3C3BD993E02B3AAA8E4B18C501E30D9E315EDF5BC63BBEDBF807BECFB71C7F08C8570228563874C824F3AF34E14D1F038C15086E083AB4A124C50972D43D8E1CC9EBB828A549';
wwv_flow_api.g_varchar2_table(35) := '9EE93F65F2DFFF27E39D7C1E5A8BC917284AD4F1B1F881BD2659F65E13DEF27B26E95A045DAC1637EB1F7EC524F9824996AC262F0539C9E54DB07FA7C93DF35754073C142E555A6885274CF8CE4F9A78F58D6979F591EF40042F7FCF043B9FA66D2CDFA2';
wwv_flow_api.g_varchar2_table(36) := 'AC0ED72F350EE0CC8AD0F2A4F362AC78295EAD640DEADF286B56A71188051E2B19BED178A7EE30C1EEFF43405FC23A004D60FA3993CC5B6CE285B83C146214C0F976FE83334A3270CA440B708B9912752D34F1B26B4D70F47184BC947650A6D49CD236A3';
wwv_flow_api.g_varchar2_table(37) := '033CDF64A2A5AB00965841DE04CB0B7EFE5DF8E837C5955824ED5A90DB0A26E2DEDFFB6EE3BFB1C398CE6E68507EE075935CF66B265A73134A48DB521294C33F79C0F86FA2A472F7D603C8ADD7373510E01268020E6BF386198FD471253A2B6B18497C46';
wwv_flow_api.g_varchar2_table(38) := '59566C3FD748BD5C01A15F89A52E47312E33B99F7C160B667C93900440349CD2B320429FBA4920775834FEBE6711F2DB4CD2C190407BD60A2F793B34B16AB95BD1B0E335E523786A5B65E22578099AF5066803BEBC3347A1F3BFC63BF1A8892FBB0650AF';
wwv_flow_api.g_varchar2_table(39) := '335E51FCF305D38E0526BE12800F7C0B32A5FEE029A2F577DA679686DAA07CB0F351E31DFAA231F33E00FDCC738CF4BA1E57EA5D831282CF9200D5676B14FD2ACA645C0ADE78C1047B9F33C19BBB4C70E43563FA4E023AFA679F03E0503FF76D265CFF6E';
wwv_flow_api.g_varchar2_table(40) := '135DFD3128F521B43E13FC0297B7EF39AC0AFA72C11AE738076FBE6882579F30FEA19FE2964F03B89EA94DDFC48B5600FA0600EDE55E0A01390545C5A328D0F556912C1DF149FBDEC937196B0F5066A9095EF90EC09F31499BC65CD5F34C7CE97A8E3B8D';
wwv_flow_api.g_varchar2_table(41) := '1926781C3E68E295F79A6839F44517859652F9875E36C1EBDFC0CAEF204F0FEC43CEF54DF46A9692ED1F96C6B8E5F79D32B91FFC0363E67E5C19AE5BA0765D8EA06E33E1BA5FC2A55F64C76BAF88C5E07A95E71FF8B0F10E3F6982E7FE807A7F6DE2B7AD';
wwv_flow_api.g_varchar2_table(42) := 'A3235222B95CB0DCF323133CFF71E86D34FEF1BB4DBC74A572F9082543441743C452ACF0D48F787EB10549CF4C7898FC6EFBDC7A06C0F322BCC0C11753F00A57E262BF65823D3798B0FB57A807BD62D1C41A26D6C88ABF8607B8CC446F7F1FD63B9F67F0';
wwv_flow_api.g_varchar2_table(43) := '8B07F051D6DC0B8FA240A78D695770593134596EEBF7875ECD8504DA114152D86FADCA1B3868BCA380F7CC274CFE992F01A0AC19D00150024F3A179A68F5EDDCE312FDAB38088EAA93E6A0398D8958CFC1E7530F200B16C02849BC6C7D5A434301409998';
wwv_flow_api.g_varchar2_table(44) := 'F6838B508475586707ED84B64DAFF784F18FECA4ACE8295AA7D8CBFF69C75359A60D1CA91F5D8E625CFC2E135FFE41948D2120920B4EBD56F0DAD3B8E6FF8695E5D457BED5EEB4FD3AFF9D658053015841E4898C15F4C8A20A044D1DAB7167371BFF953F';
wwv_flow_api.g_varchar2_table(45) := '33B95718FF00D6BA603E03ABF2F1D2353CD75879128071CBD549AE57C0E52F01A067ED389A9643B8E4278B57E22500596E5A0B2FC5B770DBD758F76DEB9580F78FEFC5D2B1E06CAEDB760963F153B8FF27A99BF2E4696CC72BC4EBEE246ABE255510660C';
wwv_flow_api.g_varchar2_table(46) := '1A5254DF7FA907DE89C8ED5C3DE5BF9ADD7ADDCF32C015DD52C0A32047818ACE9A47CA320BB7197FF7E3CC1D4FE0CE3320F9207FFB7C848A4584C72032964590A78505595DDF4B80CCB82ED064559C63A2DB78F17500CB74CB03E0F020A063858A7AA544';
wwv_flow_api.g_varchar2_table(47) := '2881A760F0E02E9E310FD7C28B7853049D5B6AFCD7BE6982C3BFB0E3ABE879BC5815AEB9C54458AF9DFE69EC26B2CFBD24DE511029AE5D0CA9E873032E9D023C969827EE43550D599D0090E5E95A6E13CBF1FAF6222401993ECEE6B949C722049B668FF9';
wwv_flow_api.g_varchar2_table(48) := '3703D4EBC04DEF24D2EEB34AA28F4127852EE6BB1B113A0B2A369ACEE315AE4271E6A5C300D6E79D3D6EFCA3B867AF0B60A55CF0ABB2F9C5F044D0F43201970DE070DF72BD5DCCAB0B7822DAE59F0330477E9E5880C0CACE79C5E144CC8ED9839A339D02';
wwv_flow_api.g_varchar2_table(49) := '2C78A69726ABA1E7B018F733863265B196CA38AC39B3049E6B4FB34A635DDA7646536729100780F8C77E62FC5344B9AA27E0B1C478C91A8602401E3A8CBB5F9FBA6D59A8E8A360FEB13D2CAEBC443B0A8C32704493EBB6554C9D1E2D45F01223ED69CA06';
wwv_flow_api.g_varchar2_table(50) := 'D0D635A390C12E02AB88683FA715311463149FDC36203905585D9F5E9A4A0D091B36ED86424A9DFF72940A5C02B57856D2C9AE752E1D72AFFDAF1AEFC82FD27A960CFF9F81059278D1B53CFB3EE7ABB97F1BCFA9433026F7EA1FC2B5868CF15A0FCFD69A';
wwv_flow_api.g_varchar2_table(51) := '33F2A2AD31D52A4CCA57F92F34349C246D0BA827D055C9325A2ED2A80BA700D7A50B1250B0C04E9552219584A5287588F9ED848DF2B0648D1A43FD83CFE1097A2D2872D386458A64E946C64C8A2DC13D77321C284AD7F879FA2891FCF394C5E556EE5649';
wwv_flow_api.g_varchar2_table(52) := 'D904D6F01E13AFFD888956DD406559377C95E6D91E0B2F5A618BAEFE0DA64597A1244C8F26DB3DAB13E24E019E3E8F63A183A0048A84A62DBB22C1D5451BD2E0470D587CB130960DBDDE4394A96EB59AA62A909802F9C79F33FE5B0453B23A3B5D626D79';
wwv_flow_api.g_varchar2_table(53) := 'F12AC0586DCF5A4E4C032CB03AF63A63B0DCB3822394C9266869BD79081A8B6E37E1860F60A59D764A25D0B5E2A5152BB97F45D6D1A5573127BE1780191A2C0D315BE2A744B1DEA75906B8A27BB212B93C9D25446D28685E1CFED4446BDF6F62A62176AA';
wwv_flow_api.g_varchar2_table(54) := '6403318ABCC5EA52DF6ECA5D55414497990001BAECD6C90B3AEC16A0360DCA168735C60B70D32B3ECAF992B42AE06BD52C75CF6F512F73CF909615B2BE4D1060A2EE7B19C3AF40D106ED986B50B8E0A5FF49158800CD8EC7001DADBF03EF7007160FF896';
wwv_flow_api.g_varchar2_table(55) := '9F6A0514CFF54B7307603B3D42785AF0289E626AF3330079D644D77C9645FB9B910082D198CB1AB31D1FF7FF389D4A1121A763DC1842B2631FF9F206568158C0384434CD2E959DEEC88A71CBF1AA77A52B4FBA6779D43B7DD878C768DF5F443DDAB52E38';
wwv_flow_api.g_varchar2_table(56) := '73CDFB29CF52241B09D6DAD5AC02B2E37B4DF0C227D874803E4BAF5A62D5344BE37AD47D0FB428A759810539534255AE6F9A6580B38EEACC1CD368038131B07D894996DF6DC277FDAB096FB887290D5317ED3C61711A1F7DD699FD7DDF263A26281A621A';
wwv_flow_api.g_varchar2_table(57) := '53C4D2AB9284EC0D6573DFD243C672FF0453177675E4A63D8DE35AD5BA7403513196AA7119A5F08FEEC63D33FFCD0370165CD9B56A868BF9579B70D3AFA63CD9A553A6536C416ADD5B1B49FE5EA64EC7F7C1A7A27158A60DED38C5AB71D543FB6144226F';
wwv_flow_api.g_varchar2_table(58) := '9CD8E1623613E396B5A28B4D78DB671010D18E02957C871D7363F663E5D064098A56B5C4E81F7DCDE4766E431FD8EB5D78AD89377ED9C4CBBB2945BDCC62916CB4F676AC731B8B248FE1CAF741F322AC8A691542F60FBFCC6600AB584200376AF77DB152';
wwv_flow_api.g_varchar2_table(59) := '0BFA602FCF01373E43F955F0948EA9E9AB36A74DDCFD2726BE640D3C69D143632A1F5A39B0CBF8FBBFC12FBC7F9355AF1FB0ADF93463F4E50C1F5A4021E062CE1D6EBCCBE40F3D83D2119567AB62D4AE776A9C2A499859CA8228E569B98FB5DF6805DB70';
wwv_flow_api.g_varchar2_table(60) := 'ABDE61A22BAE2338617746E00A70AD0903ACDD5C3FF873937FFAF3A5A54301960748568F56F08688929D9260855862B4FC2A36256E83367350BD3A2305B063BC7676589BD602850092FB153FB25E94CB3F7508F74CF41C30268B3F6998EA0EBC8A22FDBA';
wwv_flow_api.g_varchar2_table(61) := '09AFBC5543B0E5DB6E2468ADFAD5EFA66D2876685B6D82D7BE8122EEB18B1DAA6D371D96AC34F1862D2818532FEBF22D613DAE6B720AB0FA3D7E52875482431B071634A2589D012A95A49E973A2E774C542B57A755ACDC8B8F9BDC937FCBD4E529568B2E';
wwv_flow_api.g_varchar2_table(62) := '858C5CBA8A539E712D61CF78E4C072B46091DA3FE752BB2A8F9BF64EEE24183A0018521CD5E3D59F022E1A5A9EA2E75E00667124DD2F860ED39C64E13B4DF88E8F9A8460CC52C32A65C1FE1BB8FC03586FFB3A4067A8C833F74519E4B2354C6865CC7A09';
wwv_flow_api.g_varchar2_table(63) := 'BC52B8E1BDB8EA4FE27D0E5A9EC54EBD9353173DA14E5AF7A91200D67B1C2B3C908EAB12970D64B2AE722F6BC2B23DB611FDE3AF6371CC5F8F01AC7674DAAF4805AF377E59D0F7CE1C01DF34A0B10B222223770B70FE5956A814B4694DDB7A0D064945D3';
wwv_flow_api.g_varchar2_table(64) := '44B4FE7E5E0458B034CD57F02677CA1CD93FF0D3B41D2988023F6BDD7D6CF413E8B533449CD8473EE5F38CBDBD27D98F7E8CF229D87688D1985D586B6384402F07B08DA9F801D5812756CF2EBF86F9F877D23ED839B5D4A57EC929C013B30A68EA90D769';
wwv_flow_api.g_varchar2_table(65) := '821777A482B1A08FD1390976F82CE3D57102A8231480CD36AC5663A89E29698D7A887DE41FFF5B9A6FE799998A496970BF80EBF5333DD1DB1B957BB0F925AC113F8E1BFD595A4E2ED3962730EB4729D8D32DBF5CA765C91C4B9D475E30FE13AF95F2D50F';
wwv_flow_api.g_varchar2_table(66) := '8E61DE19D34B77F228E2CB2A2AE5E5AAB90F9EFD3CFA242512C3E2893AEAB3E6D65AD34E1FE861DD925380A7C625BADC2B2BE8A3780648754D091080EC6ED2AA54600250D38CAC8E84290B3EF53272523E75CA02135D8186552AA011ADF2332EB9F7349F';
wwv_flow_api.g_varchar2_table(67) := '3DF15C295FE5A1AFD76CB5EE6CCB53BFDC16E5CF00AE7D3D17F06CA2BC8F3750F94ADAF61920C2BBA7B741FBF69223FA3AB06EBD8FA580CF5A2F59754E4E015617A694344E795A21B2AA7D6E15816713CFE50E2DB0CAC8F2D3A7D662F466646619A56C7B';
wwv_flow_api.g_varchar2_table(68) := 'CAACC94E73AADB110080DF8EE589A6F8B0E53997CB57B6252B66E1A5AD82E751F42B1BCEAE5587F1378F0264FDB475E88FF53659B9FA9E9D025C2DC67159B7D12EDA3C5E3A8750A5B0AB2A09904C80958F2C8D09EAC9C2A53C592AB739561DE5A9BC3C45';
wwv_flow_api.g_varchar2_table(69) := '294D583E2B23DE2AFA39294F19717767A7008F259AF1599D5EE9F1E9E8C94C694DB75EBDCB4FDCCB993CD5C0E52C9595DA19C516A15A25E014E0E9EA77ADCCB7EA4F2E01A7004FDE5CAB44A325D002B8D1126F707B2D801B2CF04637E714E05690553B7C';
wwv_flow_api.g_varchar2_table(70) := 'AE655813C03DBB7655C65513BF1E557BDF2F080A95025587AB643C6D19D404F0E6EEEE74EA1E5B6CEDDBACD3E6A055619404320BE6457A8B7526E35185A67153D34247A65D89EF25EC9166EB49E231E3731AACB48A4A6E568892253295443219CF543AB5';
wwv_flow_api.g_varchar2_table(71) := '59F0E6B4D9C48F5FF77CEF957C9716E2ED6E36EB7A5ADB6B1DD39341124B8692650732A5AED95C92B1AE6792AA5DFEB468A06D1EEBE756D3FAFFF9AE7BFDC0FB42A1435B25A49A284F8B8DF3A370C9E70DF60F9FC639FF7EE71F7E7B873A5629E39974B4';
wwv_flow_api.g_varchar2_table(72) := '66182A19E8FFDC876EF24C7477E279FC0E3389F57A552B4D2E01BDDFC00FD871CAC9293E16F11F6D1FFFAF1FA956A56C27A752C71262A48EE42F48D2AE64FAFF8340993CB1094FC60000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72344504057797149)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/divx.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000012FD494441547801ED9DDB8F1CC515C6ABBA6766D7F6EEDA066C7C23DCEC0036C1E004271081E210200A128922D6CA1F8004B17194487989F2C0BEE4';
wwv_flow_api.g_varchar2_table(7) := '958724429178084AF025DE48B92021441470943C04212E2658011C309738BE80C1C6EBDD9D9D99AE7C5F75D774CFEC6DA6BB7AA6C7D305BD7DAB73BAFAFCEA9CAAAEEA690B612329256DA8E9A68EB131E5888BE03E9A6D58683ED0F63E8D22A5A2DCBDCF';
wwv_flow_api.g_varchar2_table(8) := '4E6E1742DE2F845AA194F01CE108FE9F5AF2A039A67E96CF536A70A8243E5EB7523C31B64DBE3FBA59B9E34A79E67E522B77071527F3BC08DC7B9E997C40BACE13C5A181151D2C7FA24BD5502D971785B874B0FAAC14855DBFDC2A8F8DBDA00A635F13B5';
wwv_flow_api.g_varchar2_table(9) := '8B057222C0A30751E377CADABDCFAAB54294FF525A3EB0A57C6EBA02A531FD2A11AFB68451465985172F5FE24CAD5F5D1AAECD545FACA9C2F77E758B7CEF62829C10C4B836AAE74D5D83B07C5DE57C4520585367E61738AF144AE826AA56A94E0C2E2F7C';
wwv_flow_api.g_varchar2_table(10) := 'D995D5BD8F1C56578FED90D5B143C2BD18DAE44480B78C8EEAB6D7959291806DB1FEABB7B995E1A55E52215C544A39FD595595860BB72BEFE2829C08F091F171421435175D16B8B006AC91F368B653584C858223E2A0F4E5CFAAB58191C26D4255F7ED3A';
wwv_flow_api.g_varchar2_table(11) := 'A236D29347F5B9DE7D4A4804D878708012212F345BB6F1FAA1255246251D87FD2A593E5FAD95460A5F9195EABE875E9DDE342E65ED6B870EF56CB84E043862A03AE3D9C7B279A4A92AEA48248019A595E573F0E4E1C2AD05E9EEA5271FDAB1A3673DD932';
wwv_flow_api.g_varchar2_table(12) := 'E06CC25CBC54FE733C0231B9C39583700DC8514FEEC570DDB7807D9735E867B5B175C8A521EDC9071E79BD7C3DC375AF41EE5BC00D213A188933B883B5863C833619E17A9BF29CFDBD08B96F013778F0FC63D0A1270F176EF621AB9EF2E4BE05AC3DD8B8';
wwv_flow_api.g_varchar2_table(13) := 'F1DC1ECC073FA6BA27235CDFAC6A95037B5E519B75B81EE7E3D5ACF01E04806CAC2C033616CBC6CD2D5A8A06379E2337CF1BC8E85DCF4CF011AAB85539D5DFFDE0B0BA91C3B4A380AC320CD932E0C52C368711BB74A8E5928619692B3983C190E270E146';
wwv_flow_api.g_varchar2_table(14) := '4F55F73F7CB8AC21EFCC3064CB80BB442BC66563C61A3F5C13F250E14647399987DCB78043C76CBB76F81D2FF6AE01D955F2C09E37D45686EB9DE3E3CED8D858A66C9AA9C2B46DEA04020D1EDC7E1B0AC8CA419B5C1D182E6EF1AA95030FBF3673CBF8CE';
wwv_flow_api.g_varchar2_table(15) := '9DB5239B1F95FAED900465B3296A197083D96C96335D5DF3F5A217B86AF01A8B8BB16B42BEDE1562DF1E0D5902F27866205B069C20F02D60CCAC9EC2DD728CD3C52C94868C3788F6ED3E3CB38D9E2C1E15220B9E6C19708F7A70DC1A84D9330D59FA904B';
wwv_flow_api.g_varchar2_table(16) := 'F0644C58ECDFF5EACCAD63527A59806C1970EF78B09592F2058708643C42C1930B9FC7D17D59816C19705C57E8BC5C43AC69BF931516584346AC66B8369E3C52DCE848B9370B90FB167048085B313A598DF2FE9E814C4FC673F22642DEF39ADADECD70DD';
wwv_flow_api.g_varchar2_table(17) := 'B78001234C493C38D4A28735EB90D1BB26644F540EEC7EA5725BB720F72DE086109DD4830DE4A0D6442197868A572B47EDDBFD7A7720F72D60C344AF6D7970446914F2C050F12AE17507727F03366E6CCB832380390B55878C112F783221EFFFFECB953B';
wwv_flow_api.g_varchar2_table(18) := '74B846DE4E3C275B066C2C16BDD30C6F072135951206BA35640C8670581390AF745C0C86BC52B9736C0CCFC948630A3F7A4B3159569EA6C5EC5AA19325AD4346C70B2F0D6CC0ABF64FED390C4F06E447D1354B13B265C07621A4A9ADD3B14643C67332DE';
wwv_flow_api.g_varchar2_table(19) := 'F1AA9696BA57E0978D7BD1F1BA133F0A51632942EE5BC09DF46053510919FFF9E17A59F10AE1897D8F1CAE7C9DCFE16941EE5BC00D1EDCB06370A4B6F6215FA85610AED7A303FFDB34215B06DC594BD943D0F117E718400AE87801B2BBCEF3C453E878DD';
wwv_flow_api.g_varchar2_table(20) := '9586275B06DC8DC0970073581FF52FD0B4261ED30BFEF0B7562D2F945B243F35D775EBA9460D196F86AC158EFCCDEE57A7EFD6903113357AF020A6989327CB8059FA9E4C0C9B04E4AFB9AD7F0A8B8D96D72DC8F86D70A0933BFAAA45FF11CA5D2764E1A9';
wwv_flow_api.g_varchar2_table(21) := '5D872BDFA40539A76CE339D932605AA6175258113163AF5C477A981810AEEB78D2C1A4504717474957BAD5496F6660D85D8DDF5A3FF9A3379586AC9F95138EB225FF084B2FF09C554656447C8A003F192D5795FBC92717A685F026F4F43DF332D4D27375';
wwv_flow_api.g_varchar2_table(22) := '3CE50193CC315391595122C7B41CF39A6346AEF918CE9B6B44D79FC809B750BCBC522E3FF69D674E1DFDE3B72E7F87EF5DE33B0AB5A8A676B6FB14B06F22FE98B05C130327A7952B262794E7D5F058CAA0167A783BC64C9617D0A52AE28D909AE3C81BA0';
wwv_flow_api.g_varchar2_table(23) := '6B039677B68C0AE57F28239EF63E06EC7B191A5DE9969614153C564E4D802D461035E478064D24E521AA944AA2569DA94A7C4B2291AE40B88F01D30226947A4A1607B449D434207B88885DF064840F0C70792E7D194F51BA3CE633197A27C61FCB9DAC18';
wwv_flow_api.g_varchar2_table(24) := '25E8BA086CC9C6179D194096727008AEEC487C268D11BCA30BFA7BAC717E0A5CAFE93319E66CCBEB1C70D454E8F0D093E59261FCA610A66107A8932985CB59069C42093B69605EABDB90CDFD5A6981F9DB57AB298C3056D5765A59B72047CD67A9776419';
wwv_flow_api.g_varchar2_table(25) := '70A749A478BD6E41B67C4B39E0850CDA69C829B47039E08500F35C27214743F462E56AF1BC65C02954C1166F24D56C9D829C82F92C034EA10AA64AAE0DE59D809C82F92C034EA10AB6C120F5ACB320EB1723ED5D3605F359EA8C9B7B4CA10A1AD5595907';
wwv_flow_api.g_varchar2_table(26) := '90591CC5B16B3DAC69E9BEA36AB2F91C9C150A2997A3C193F1E205F6AD274BAE6739445BBFCDEC2AD4904BC1B026215B08D729D4931C70922AD400192E97862727291F6473C0090DE83F27079EEC26F4E4681B9CB45C817C0ED886218D270F72168A9E1C';
wwv_flow_api.g_varchar2_table(27) := '335CE721DA068D947418C89C6A74B313AE730FB6C9DB40A627270DD7F963924D32167505909D8C7872EEC116D9D65501B22894840F3966C72B7F0EAE9B339B1B0D905BEC78E5BDE86CB29CB7547120CFAB2CDE893C44C7B35BEB5275C82341EF7A8147A8';
wwv_flow_api.g_varchar2_table(28) := 'FC31A975BB662AA7865C449BDC0264CB05CF3DD8B241E75557876C9E9317F0E47995B47F2207DCBECDE24B34846BFCCBD4CD235ED14E56FE1C1CDFCE5D956CF0E426C8D136387F4CEA2AA66417A7E716D826335C4720E71E9CCCAED99106C9853C9905CD';
wwv_flow_api.g_varchar2_table(29) := '3D383BB862976416E4488CCEDBE0D866CD9660245C4B1DAE03C8B907678B53FCD2305CFB6D327FD528D136DB7C33C4523D897F7BB9242D1040C63CB22CA0E355437CAECE58314D0ED88A196D2869EC7879951CB00DAB664F079B60BEF6B3C4FFA444D202';
wwv_flow_api.g_varchar2_table(30) := 'E62359492D988A3C2957AC68CE6C88E62D06FDC9796F14414D27B39E37234E34EBA34C9A720B95A593E732079820185606617DAEB94F1051D8669FC3F5FC42580D27CDD0FD5CD0285BC209F44FEBFA98BF8C1351BD38342B0D408E46623EEAA6DCF46242';
wwv_flow_api.g_varchar2_table(31) := 'C893959429C0B41B5E701133D838868EE405AC8BB0EA5CF62C21DF08CE0D6359829A40101C1BA82033361B122BCA699C3C013AFC46112B04E5D6E362DC9F4B3F1550CF09C89D6A92DB00AB99CAC77C594E99024CA311EE1036EE5EA2B4D71186FEAA60C4';
wwv_flow_api.g_varchar2_table(32) := '8A1C0062BEB370DFE35529FE45B2D8DF88BB1986ACF14C0262E2E9CD834A7C15E7914DC39906B4F767A4D6C3EBCE95181D6E82DCF226B96365A975CE273797AE6E1DCB0C601A7E09881C058D6F03EE839BAA62C5003F3528F1A5DDD9E6A902D004F29E03';
wwv_flow_api.g_varchar2_table(33) := 'A4D35352BC714E8AE7CF39E26DF44DAEC55DE1B48649BD9F6267F73A4F6C5F551315E82BBA4A9C9A94E2B1A305F10E60AD0429C23489E0AA10C46F07C5031B3CB1F5D250EEF4A4237EF666419CC4B5479AE48C7C96D699024C906760D84184CECB00F912';
wwv_flow_api.g_varchar2_table(34) := '2CD330243EFE1A0CEE18D2FE6797D7C092F46E7AF9ED007D17003F7DDC157F06ECAB70670CBF15C02D23DF8A9212AB972A3183CC25E8A74C118008524708AC9B13CFAD44255B05B98A91C3E706A917C59AD51434CB67613F3380690C86DEA558D3B0D308';
wwv_flow_api.g_varchar2_table(35) := 'BD53B02201E313BBDAA8AE430AE693CE52D4008F79593196A351FED2EA9AD8300420C75CF1E4474E1D32C5F0D151E89300E5C39D862783950ED7BCF65C899E4C39962594F3CBC9732C4DD653A600D325182A693C7AADAB17290A38C0907A12E11159B487';
wwv_flow_api.g_varchar2_table(36) := '2F2DF81E3E0CCFAC0296EFE952AC5DE6899DD728F169A5289EA627C35B098295803AF577A18335952D06A9598E958D49CB717331053A77F7FE640B706007DF66FC4CA41F9A1DB8E0BFCF3AE2A7EF14C46580CD4ED852B4A3372074EEB8DC13375DE6E9B0';
wwv_flow_api.g_varchar2_table(37) := 'CB703C5991E2721CBF6F7D4DBC7CA1A03B624B7D26D06EE0040770A1FAA9051984720D3C1B761654D0B5937496ECA406836127D8A779194ECF122016F69EFF83CED1AFCF38E2C76F17C40B6877D9A616909122559CBF76B927EE18F1C487D80E21060A8D';
wwv_flow_api.g_varchar2_table(38) := 'E296EF3CAE5CCB17482D63B6008724FC1B8EECB3637305C2EDA5EC8021EEACC3F2450CD74E01E0E31FBAE22D7878015E4D912A3EDA3A545462D3B0D2032653A8147E64350ACDBA55BB9AFC7EFBDFAA5416F2650BB071146399609F2B76C026B17014A90C';
wwv_flow_api.g_varchar2_table(39) := '607C8EA5376FC4F0D4EB987879F96347B0E3442FD69D27ACD7A017BE1615E213C8F888B0A1935907BB8BAE4C7EBFF75E0F2D8BCA753F8365C0C610316FCC38CA5CE238C7C272A137B2F303E7D5C17625B68FA113761EA00B68AF099879F868C467D5FF26';
wwv_flow_api.g_varchar2_table(40) := '2C5643716CEA6A509CCE8E65C0B06A0AC9D7EAFF35F6E59A47CC152FE0718ABD698235E718D61B873A4D6EB36EB7B0BEFEF0AAEDCA773EBF65C0C6FC69DC48447764D35C89600D5C738CD910C523C9089A75E4544B9B7D1FA2E37A4660DD79EC1E3D6CAE';
wwv_flow_api.g_varchar2_table(41) := '60D604C850BD129DAA123A596CAB596BB9BE80018A0BC87099C91C5CA69F56D97A0E6E0611ECFB2B3E17FBE1976BF35844585338B0092358231CF4C03FB5C0F699E04F618CFA14E8AFC63E65C2D01A28C611FF78B8D6D966FD09F3FBA7C27D236F44C233';
wwv_flow_api.g_varchar2_table(42) := 'E64877D79643B4CD9B094D4523122FDB53F692B9708A903347EC41DF8EDEF2360C7670C48B43972ED61C5E7C6F428A3320CDA9417A74736245A04E74B4F59C2F6B3B17B6DDF8BF0E1F9B41F21F9338C2C632309F91D1E5422ECA652965CB831B2CD34804';
wwv_flow_api.g_varchar2_table(43) := 'FFF08D0EB74B90074EAA073D5E82777E03CFC20F5D5913578D702201272056444FFABDCF1CF14F0C55AE016CB6CDB312F2E9912F54008E8CB1629804711D0142319EE41E9B004C31A2007CB6D6E3E64628903795C31CEEF63AC38009CBB75A605AF11136';
wwv_flow_api.g_varchar2_table(44) := '08B804209BD0E67E176179C71A4FDC7089A7B3720A9133515300FDF753AE78795A8A4DB8C3E338DE98A017D431AA29CEE0045E5415D17718A15EF085025ED74FE116F7CBF0E0B338CBE94DBE60104DCBB063DE1C891EEFD67686011302CC82A5068FD9BC';
wwv_flow_api.g_varchar2_table(45) := '5289F1EBABDA1B190E39C9B01AA1992356159CA737122EFFD1D67F1C2F88BDA71DF139EE23B113E6278C74012CF551EE87D7D4C42E9C64A866627DA2B7D30B0F9D72C4CF3178E2A7408E2364B8EE4F36D6EAB358468E3AC8FAF9938EF8D3A78E58836B87';
wwv_flow_api.g_varchar2_table(46) := 'D70DD474619539C011936A83D3E8F4CC359840588F992293684C866DBE104020CB008C9E4BB88F7FE092332624FC112FEA647E8657EAA3E15919BE70A987FAC3334CFE16FFB22D7FF73C66AF70392DC77394C332088B6D5D65E47061E4E0002967AA58BA';
wwv_flow_api.g_varchar2_table(47) := 'A398933E8EB0C0A154E6EF76B20C38F91DE19F01D58F3925348403FAB18700CDF367682E9A564F27E20E089986FDDB0957ECC33C30C4C44A00E46B3DCC47A09CDCA73E56866829B9CD3CFA282A40B053CFC4E68072AC24D114CAE168446164339ABD6BDB';
wwv_flow_api.g_varchar2_table(48) := '9601FBA68A733794E410E32A6CB00373028F385CFBAFEC44FD0CF6443E768ACA783D878F426F061DAA97D0E65E09B0F45CC2C54AFF637188E4E20C669F8E633E99D180F20CC558E9644AED1F478502CDB3E8857308F423E83C7E2190436EE635721466BF';
wwv_flow_api.g_varchar2_table(49) := '9A729C67A6077F8632518EC7B2902C038E7F57341C5F9663BBC9F7A47E81F7A5F80843E875AF0A36798C930D9FC273F9B6E447D8E660C675B81BEA319E4B8333AD00B03FFCCF117F45BB6C8EF138F34693B9148F7F0C50DBA0EFE071473C8376B51539EA';
wwv_flow_api.g_varchar2_table(50) := 'A2DC06DC038A9589641970B27BA211D981A2E71EC6E4016CE57B61935A0260C864DE655856E12ED8C9618F963A783E9AE8C91FE09DAD09BC9CD57C2E9ACF6C13342B05DFCDE61B947C7D773139533928C75778B99F856419F0626658F896296D20AF41C9';
wwv_flow_api.g_varchar2_table(51) := '5AD1C6FCECCC98F7A1E792A1B139ABC4D0D96A6213C0B67B39E42E8921D78648AB458A95CF32E0E4F59686A11686D95613651633286145073316D36D74C6955B4C7FA7CE5B06BC98995BBF2D7B9AC26BC6D519572EBC72F7B610806CA636DCCEE665735D';
wwv_flow_api.g_varchar2_table(52) := 'F35AC032E05EAEEBF3DAA8A74F5806DCD3B6B8280B9F03BE28B1863795030E6D71516E59069C77B292D712BB364C04F8C8F878B457C539B5E4F7D7EF1AA283E4B045938DDBB64E22C05B46477575736B9AAC3FEA9E336E1B425D80B6D3331E18A2F56D2A';
wwv_flow_api.g_varchar2_table(53) := '8C8DEB79DADC4834D0616A574D2985D914FF95467F7AD46E9C69F3A67A363B6DE74F4329DA94F7616C1CF79E12011662545F17BFFE7B17C3FD6F15878B5BCAE7F8BE449EE25800D3D15E69B8E8CE9CF3DE729C41D894C9B7B1BFDDFEDF642CF88A043D17';
wwv_flow_api.g_varchar2_table(54) := 'E99E67261F90AEF34471686045FBC5C8258C052AE7A7CF29A91E7CEEDEA5BFD7C722363679DA592703CC2B450A70EFB393DB31EC7F3F0EAED06FB038899AF876EEA3A7F37A1E5E01C25B3FB0DD59C4E6A79FBB6FE98BFA8622B6EDEE0DB22079B26B014B';
wwv_flow_api.g_varchar2_table(55) := '36FD3FD5DF5DA88C0D16B00000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72344916606797151)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/dll.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000017E5494441547801ED9D796C1CD77DC7DFCCEC2E49891475529628D9962DC9B22457B65B1F09D24476EAA3296A047028B468913F8A184D2CBB4091B6';
wwv_flow_api.g_varchar2_table(7) := 'FF9A05DAFE19A045DB1875D3A6A9252B66AE3687E5A468DC22B5DDC0B123C772235FF2254BB2649D14AFDD9DE9E7FB661F39A4487AB93B7B50DC27CDCECC3B7EEFBDDFF777BC6366684C1A218ABC34C83492467F7FE49B4BA01F537998991A31E77B31C5';
wwv_flow_api.g_varchar2_table(8) := 'F32295BB6BFFD8CDC614EF31265A1A4526F48D6FF4BF6621847285F4D5BE308ADA3B73E6E4DA65E691FE1BBDB7FAB646C1401485AE3F356B771D0957A7790970EF7C72E8335EE4FD63B6ABBDBB8EEDAFAAAA2262D99D3566457B61BF670AF7FFED8E8EC3';
wwv_flow_api.g_varchar2_table(9) := 'FD3F8E32FD3B4DF15201B92A80FB1E47E27779C5BBF6476B8C19FD51AEBB6DDBE8D9913C442BD4ABAAF09A5361DAE815D0E2EE0E7FB8B727D715E60BCF16C2CCEF3E7C83F7E6A5047295400C58A686E1F05598E56BF2E7F306632D9A4D7FA0BC9E898C75';
wwv_flow_api.g_varchar2_table(10) := '51C57C61B06D49E6D6C02BEC79E040B4A1FF36AFD0FF94092E059F5C15C0DBFAFAACEF0D3C4F9640BED8FEDA6B5D35F131DE52630284D21B395788725D998F46E1A5057255001F1C181088A618306441852DC01672C5367798686644C3B138B47EF45CA1';
wwv_flow_api.g_varchar2_table(11) := '88267F248C0A7BEFFF59B4519ADC67D3E6EF2CA12A809D0697A0C4E44DB0ADB9E18D4D4BA28D91E7FB1A5779A3E70BC576CCB51714F6FEE10B239B063CAFB8F3A9A7E6ADB9AE0AE00483C631BE38AE3963A688A2B544069869AD377A164DEECADC94F182';
wwv_flow_api.g_varchar2_table(12) := '3DF71F8C363E75DB6DF356935306B839C1FCF056C5F3780CB17047954BE61A90BDFC8426CF4773BD60018E55D6417F918F1D0739D7693579DF03CF8D6E91B99E6F202F58802799E8D24A9C83BB74B6208FE19331D7374619FFB1075E9C7F202F58802769';
wwv_flow_api.g_varchar2_table(13) := 'F0CC6BD0139ADC95B93E0A057234AF3479C1026C35D8A9F1F41AAC899FC2B82663AEAF8F8AF97D0F3E3FBAD59AEB014DAF2E32EF2503D01CA79401761C6B8ECE7D682B26A9F134B995EE4066743D365828E6966477147DFFEB7F7420DAAE65DA3E408E9A';
wwv_flow_api.g_varchar2_table(14) := '18E49401FE308E4DC3C4064595DDD2898CE29537A6C590AECC7616431EFBFC81510BF2AE26063965801B845605D556686B62730DC8D9CECC763FF29A1EE4050BF08462CE593AE2819746D79DD9ED41E4E193A31D32D7BB0606FCFEFEFEA6E269533566CE';
wwv_flow_api.g_varchar2_table(15) := 'ACAEA2C0240D9EBB0F05E4C8C72717DABAB2DB423FBFEFF33F1FBB6160D7AEE2C1AD0F79F6E9902ADA9666D194019EC4B634DB595B5A338DA267A9B5F4184BC0DAB540DE1218B3F7410BB207C8034D0372CA005761F8666166B326D15BAD7106EC425990';
wwv_flow_api.g_varchar2_table(16) := '798268EFEE0363374A93CD43C6348326A70CF03CD5E04A2588DD330BB217839C4393D9B078ECFE17C66EEAF7BCB019404E19E0F9A3C1A9B4540F382440660A8526673613BBB759404E19E04A55A1FEE526D99AB90FB2261A6C41C656CB5C3B4D5E92DDE8';
wwv_flow_api.g_varchar2_table(17) := '7BDE9E660079C1023C811057150CB226978FEF1CC8D264E6C99BA4C9F8E45B1A69AE172CC0307F2254A3C11354ECB2E638C88CAEF1C91B4DE43FB6FBF9FC471A05F28205789289AE56831DC825A999047267B021F2A3BDBB5F6C0CC80B166087893DA7A5';
wwv_flow_api.g_varchar2_table(18) := 'C109A2E3206B31A4337BA509057254774D5ED8003B354E4B8313006B17CA82CC3C592B5E390B72F1B1070FE47FDD9A6BF2D6639E9C32C08E63C99E36F175C9A4D6A48525DA93410EAEE0C5A73DF8E48FF7F7334F26F447BCF456C39032F15A722C5D2ED4';
wwv_flow_api.g_varchar2_table(19) := 'B3A5E3206BE0B538586F7CEF51ABC980FC1043B35A829C32C0E982504B6AF5B6351664E6C93CE36541E6CDC63D0CBC3ECE4B21517F0D415EB000D753839DA00A64FEC53E797176BD09BDBD0F1CC8DFAE7978AD405EB0004FD2E049370E8E9A9D63902F14';
wwv_flow_api.g_varchar2_table(20) := 'F2B9CEA09701FCBFD612E49401AE2FA7D283A0EE0FCEC98064185D0BE4B50279F781FC276BA1C92903DC08C35705CC13F268DF40B39414670F7EF4AE55D987CA7D487E5176B4B576ED405E1CAC6517EA6BBB5FC8DF61416627AAEFF1C7D962AE3EA40CB0';
wwv_flow_api.g_varchar2_table(21) := '5A3F2F83CCA6008ACFBAB6AFC27251F6B98C32B10F8E692ABBFD6FB2F13C19903DEFD1FB0FE4EF26C9684F398D7972CA008B33F3214C08226A1405BE17B2FB6382C00F3D9F4DA1BA1E3CBA17F02EE35038D6D615F4F0AEF557FFF8979105D9CE95AB5C65';
wwv_flow_api.g_varchar2_table(22) := 'ABFE232CF301CF8BDA2841E45304BC323A5A888253A72E8C18130EDAED7BE595A995E65A7BAA08175C9C1364094A22CE96535E17E7CA4D8D23DDD5913C9FF206834C76757E74F44B9FFEC1F157BFF3A9D5AFEBB96BBEA3504C529ACBF502053866915E26';
wwv_flow_api.g_varchar2_table(23) := '1C2D9AB6632351608606A3302C322D95519BD0F0B930B3BABC80EE45597C31CFD57BD7426B1DC7EBDBFA4C147F28A332EA0B18E058CB70BA5E90EBC84668AC373C08B6AC205A902B636855A542AC4A2E678A85B182C7B724AAA2552ABC800116079C290D';
wwv_flow_api.g_varchar2_table(24) := '232FDB6659128D007288456C8026633E58E00A03E932036CDB1EF7990C7B53C14FCA83AC0A5AD0F022F052CE97C10C207B5E7B27AAEC7B7C264D16BCAE07E33D495C1C4AAA37E533192EB5EC730BE024AB18F04893BD8E2EDE2984351A00D533D4A0BA94';
wwv_flow_api.g_varchar2_table(25) := '01AE410BEBC960D5D568905D7F53F1C07AF735D530616152255B6F628D0239C9BE94464729035C6F246A585FA3404EB94B2D80676368BD41AE81876B013C1BC04AAB27C84913FD61ED2A333D65806B20826576A4A6D9EA05720DD89732C03510C19A2237';
wwv_flow_api.g_varchar2_table(26) := '07E2F500B906EC4B19E01A88E01C30A879D68B40B60F46A6576D0DD897D260DCF5B10622E84837CBB904B29A1369EDDA2E6BA6D4EF2499E69C07370B0A356EC7244DE6C10BEE530F29A95ECA263AF56E362F410B72AEB4AC29905330D735909316C0D588';
wwv_flow_api.g_varchar2_table(27) := 'D0249051B95A687235EDA36C0BE02A1918CF934B9A1C54A9C9491F5C6DBB4AE55B00A7C148A7C9EDDA8592265768AE5B263A0D346A44C381ACADC6A079CC754B83D3C4DB812C4DAED65CB7A64969229322AD12C87E9368724B8353C4769C14209B4CCEC4';
wwv_flow_api.g_varchar2_table(28) := '205738F06ACD83C7D9D99C1793402E73E0D51A4537279633B6AA12906724565942CB4457C6B7F24B8D83BCA434BA9E650AD59A2695CFD7A6CA6941CEE293CB0039E586B734386586CE486E1C64374F9E4593672432F78416C073E759E52526996BFE32F5';
wwv_flow_api.g_varchar2_table(29) := 'D415AFE420AB350FAE9CCF0D2D394993A7809CF4C1AD69524361AAAE72696E463E59E63A01724B83ABE36BF39406C9D934590D6D6970F3C055714B2E023961A35B3EB862B63657C184B9F6ACB92E81DCD2E0E6C2A9F2D6C85CC73E596F357AF8E6349F0C';
wwv_flow_api.g_varchar2_table(30) := '49494E2AEF5EABA4385002997D642FC3C0AB887D2E8CA5C29A16C0A9B0310D2293075E61BE05701A5C6D3E1A72C17AECA723FEA444B50D6CAD6455CBC19A9417CAF9542837858956774A63C7193B8501B3C19D67CC384342927E92868B4FC6CD4062DAE8';
wwv_flow_api.g_varchar2_table(31) := '99CA2B5E87E8564A7BDA0AE718D95080C50099907638A0B36356B20F628EE2B534AFAF8115B971CBF4E5304E65952FC78F3AEB68E9AC3A7588DE58896E3934C96EE9F0AC86C952C0D1104D05D170873CA9DADCA8D05080C598029D7F9B41E339CE62D674';
wwv_flow_api.g_varchar2_table(32) := 'BC90375A425A27053A38B771681D204F662E670CA2256055CF19A4E308480AC86450F91E32AC062DD5AF74659989AED2444F4239CA8DDAFE017495DF099ED2956F11916BB869E7D07D2342C3001643046E079DDFD91E592638062519A1C51E31D20254F0';
wwv_flow_api.g_varchar2_table(33) := 'CC2F60A8E236D1F22ECA2A8DFFD30222104E03EC218E1D3963EE591C991EEA5A42597D8C6A88F893A8D81BC39E797AC4332B89EB254DED22E9229AAA4702238D7C09172981B8097A57B41BB33C1799457AFC8A3CC3143E473B8F43F3F098670A742C435E';
wwv_flow_api.g_varchar2_table(34) := 'A5D53B340C6075F8048CB81A06DDB7A96056731E2D7AFC39838B599087418330EC1CCC7A7FC8332F9DF3CC7F9EF5CD2198BC911E48301C2062A24888F96F90DECBBAC19F5F169AEB978766CD22042913990C82A13C026A8C82A700E2FFCEF8E689F77DF3';
wwv_flow_api.g_varchar2_table(35) := '13E84B78C418AA1C07597405EE39F21FA5C2BEA591F9D8CAD06CE80A4D775B64B280EB40145D819AA73F2F7CE09B47DE0ECC30F7B23E6A673D43C3001683650E73307B25E0AE82F9637046DF00153393DF04D3BDFD229918C4CD4701FA9300FCBDF702F3';
wwv_flow_api.g_varchar2_table(36) := 'ED339EB99A5EC81F3A9005EEEB807B7B57647EEFF2A2D902B8ED019F19A36C51DF1AB315C442B088B2CBDB01AA3B34D72DF7CD66C0D80328EB0418341DC802F724157412FF97D0BCF5B2A2590EB01248BE93C777D3C8ACC0BDA54FBE8E8ED05A8945477C';
wwv_flow_api.g_varchar2_table(37) := '2C906716D357590765A9576818C0E2B1CCA4F83242E747E0241F06B59D9786051CE29498A18F3817F9F09C98238676636E7FADA768D6A33DAB0F67CC97D1BCCDF444B404C46B807BF7122CC3C68205AE00FDE13C9F0B8666D677DF93D3572A23A3B45168';
wwv_flow_api.g_varchar2_table(38) := 'ABCE0D4B42F3D98D68A397315F39E19BABA0A966487864EA5770FFC5AB0AE6A6D52171B1C5E1F392B1F62240BAB64185005D5A2C0B21C1523F94AC733D43C3004E763880D1024E800B0499E1F72EC480B471BF08B3BABC03DF899F93D99330E8FBCE97A1';
wwv_flow_api.g_varchar2_table(39) := 'F5F76E2898136359F34D34793BC0BF0BB8BF8245F82CF157A19502568C6FA3A762F6EB68FE517CAE2CC16A7CA78464316912AE21F2CA9ADCBBA168DE1BF5CC0F71059B30F1E7010A19300F5E5930B7A0B912B621DA91A56D39DA7696BC472FF8E603CE72';
wwv_flow_api.g_varchar2_table(40) := '279DD05B8676AF63D551A6DB09B2FA5CEFD0308025CD0A3AC77A8A66719D41C35E3D1398FB5E0BCCB5B44E1AD985766C01CCDBD09C1DF8BD1C4C1323055E0FC0DFB3AE689E1DCC58FFC83BF766D7DAD06C5C1AF22D68C0E55E7EF703FCECF7DFC998274E';
wwv_flow_api.g_varchar2_table(41) := '0284B48A78BE4A69EEC07C7F1A93BB7631F9016D88326BB8FEEDB545F3DC858C1984C0498EFBA8FB160E7DC2324F79B541349E7F3F30DFC755BC84409E269F4C7A07C772EABC0517B11C81514664CF0A15A7BA0619938684C9D22C56E9888334EE5D9835';
wwv_flow_api.g_varchar2_table(42) := 'CC21D3F81A9AF155FCE29FBC92313F3E12C0A828D60AF24913655AEF04D0FFE0B3DEBFD119991D2B30A1542021C821301700ED9B6F66CC17DE457BD1704DBB505E3344FA9F1EF5CDBEC38139431D39E7A789DFB22C349F80EEB3E4DF84E5F8C41A3E2C4D';
wwv_flow_api.g_varchar2_table(43) := 'FA186932E76AEF33C77CF367873266DF69CF0A0DCA6E1673A84D6F314EF80784E92B807F0EC1D15489A2750F0D0378724F05F704E40267071AB28C6315C75A34F97A544003992F31087A9511AF345D0332994B0D94B6E073156EC02CAF406BE45BADD9A7';
wwv_flow_api.g_varchar2_table(44) := '872F211CFF8C4FDD49BECB4141533331BC87FB3BA0FBB553BEF90579444F650AD0943BD80A4D69F0ADDD111A0E4DE249B675BF79CE377FF7A6C0A34E68A89D1A44897637D79A6E5D4B5D5D146804B09619FCD09C660802270648ADD195163E34CAD63C77';
wwv_flow_api.g_varchar2_table(45) := 'B87416D3DE41A39E3D11A049F86898276D11D89ADF1A18BA16932D4DD3804CE932BB3F074059038D8005981648942EDF2A5046391FC4375FC0E48B56917B955D8F5BD008EB6AAC82CCBC8B97657801EDFC2E667F33750E914D6D145D1D6AF748E95A5327';
wwv_flow_api.g_varchar2_table(46) := 'FE372CA40C30BDAA384C66831AA6181DBA86A716CC65DC1C6610366C075A44129447039EBB19D874A24DBAD7C83500AC732C64BC0B1032C92E38BA3A4B9C04E651F268F0A66BF542DADC998DCCEDD0D380497915CFDFEB308308C22F077DB3953AE5736D';
wwv_flow_api.g_varchar2_table(47) := 'BCCA4C39B8ADFBBC577526837897625017CB0B624A25410DBE8059D4D44AD31CCB5DE204884CAEE6BB2E28EF30FE57AB601AACA97513A9EE1A4BA07CE49109B699444019B95D85E62E414B5D90099755388E25D1204D82C769C6305BDA8C85524C4819E0';
wwv_flow_api.g_varchar2_table(48) := '24FB666FE5C51D9FB96C3245D702C42F41E5D23430D3B5005070F153AF6DE2941F15517E69FD7828D1515D9A3B2783EEC6819D9C94CCD614D729037C316C33F5722E7C715455064533DD685407DA6A171094C8A1458513D8CBBCB4308EB220C87776D34B';
wwv_flow_api.g_varchar2_table(49) := 'F9469577B45C1E9D45B31D24E57F93A188A69E2751236717944323732D7AC8EFCA7234734819E04ABB2A2E394EC56731D21DD24EC56AC0729AEBCD2C4EB4C3602D3B2A5E839F334C4BF633D5916F5639315E4B884BF0A1BD0CC098418D07A52BB8B35DF4';
wwv_flow_api.g_varchar2_table(50) := 'C0CFB623389AE7AAAC84E734FEFB65FCED790E1744B30B9A9B18551FA45E997EE1EF68299FAEDD7DA319DCB0FA275826962443CC1AED0481A10555530F8D76B504F9AB4C626F66B12383FF15B09A93CA1FBF314801D24F3258922F8DA73BCC79F1C9DA68';
wwv_flow_api.g_varchar2_table(51) := 'B0236AF22F223FFFAD6068FB51A35DE5BD8E79B406551A212BAF2CC1DBAC4E694D5B9B111202E5539DD2E01B996BDF84401C237D0974247CA2AB43D76ABFDDD6A41C451A16D49E868418C6E9ABB6DA0357EC1489F351B4F25BA8E05A18BA9BE5C2F5AC10';
wwv_flow_api.g_varchar2_table(52) := '0900699A46CAC75845FADFB331875FE4AC91B346D5A2238DBC0E30FE6055687E44BC005150FD27A1BB7FD498CF21305A21537E01290005AA76AD145EE6AC654C37C296E5D884407C9115B0C3E47F1E1A9A86C9D4ABFC08D76F51CF33D437449C04B551A1';
wwv_flow_api.g_varchar2_table(53) := '6100C7AC9BBEDBF0CF1C2549CCD15FB8DF84F9FCAB9ED0FCC535F142BF4AC9E76AB950DAFB5FC702F334EBCB9F42BBF7339FD5428846D8D23869642782D18760FCFDBAD02CE7FA08481CE5D0FEED5FF786E677587B5E8AD91D83960591720758F8F86F04';
wwv_flow_api.g_varchar2_table(54) := '6727F1DA9A7C83850D0993DAADBAA5A5B7F516CD3FB1D5790F0B211236D17D8F34BC85B98EF9783F4BA65F6019B58B718004A011CC6EA47009A78B82CCEB66B4E3A9ADF1FC54206955496BCEB1098D17F43528921EFECFD18CF997E3BED9C0BDFCA1F68D';
wwv_flow_api.g_varchar2_table(55) := 'BFCD72A6B4BC9735654D93B4C9B09205E25DEC04DDDAC3B409ED54D03EAEF22D06004D7D14F81B685640BEC512A66661CBE0905CC3F7A07939BE5F73E211684A70B4D5F93140D4B2E6B1211653C8272ADA605886DFEFC54F1F61CEFE6FB44F8643C2A3F1';
wwv_flow_api.g_varchar2_table(56) := '443D43C300563F6396C6A654E65171D28ED5AC2069F13F0E712E993E8120262D068461AE7FC23AEFDFB05C68D79661B6569436A0A14F9C67A789F5E5DFDF180B860019057869FC3580E182284BA0942E5FDE06D0EF9CF7CD1EB6209F03982BE18E7CF43A';
wwv_flow_api.g_varchar2_table(57) := 'CEDF61B76AED9B19D387907451BFDAA24D0709600FC2B37A51D1B65F34E3BE401309D192A94095F672AA7B4819E0F2BB2046D8810B672DF26B3024C415AFE028C5F7B136EB037232A3AF61326596F7B00FAC624B014ECB830AA2A9A73C1E65297134CC98';
wwv_flow_api.g_varchar2_table(58) := '7BAF28DACD8836F248EBB4DD98AC4302B308C034157A9132FBDECA9827F1B9574003FCEC00494CEA05A12FB3B9305ACC98DF5A5F34BD9D216D8E05329E9A4DD0553BECF880F4785FBBD41FDAA666BAFA95AFD6416D4F3194DF74E9917D708D8B63767F36';
wwv_flow_api.g_varchar2_table(59) := '36A5D20805C708694301A72C0D3C4EBE4380FB0C03A9E730B397C340F95181EB6A1628445980BECE1AF4AB68E26FE2BFB7A3B93D58066D4CB820CD3A87ED3C76213007C8FB5D36240E333012B8AA5F6D145DAAB63EB717C20F23542FE39BEF60D0760DAE';
wwv_flow_api.g_varchar2_table(60) := '6415AE4334956F3C3F17E7A17B7AC4373F3D19EF26E9013C974ED6BA854477D3A8536C292F68B17F295A718411C9C3AF65C6E793AEB4034C20C84C9EC18C1E87D327E0D20A12F50487F224C15559C53990F528CF2BCC8D7FC60ED416B4EF5A4C690F3E54';
wwv_flow_api.g_varchar2_table(61) := '16434F5C6879F228E92F23389A0EADA43D5760E2D5B62418A26941E62CEB20F3FDF45B81B9063FBD9945EE1EC6087AA040412E4673F1F7E8D7AB08E129AEB5D0A2419968D63B949A55EF6AE3FA641E651A5F8261288E0567BA964823C5A0C51CAB68B11D';
wwv_flow_api.g_varchar2_table(62) := '1D4F0121598E6CE3E6750DF95790F73802F2CA5984855AD469A22CC3B5392F00049CEA90C0284D349241F70299AC663D79B50325100F698A446EB5D1D5ABB3F68535CF166DF553341B11D4D71483BA567E50A7ED2085569453521A201FAB6547E59FAD8C';
wwv_flow_api.g_varchar2_table(63) := '4BD35C5ACCD77EED4A0E379823CA96772E415AABBCB3D1551A596C3E0983363756298E48C5BB20FF2B415070D620BEABFF6FCA0027BB597E67DC00A99C12B301305D79E597C996604C575600A8D5D3A54D474F71CA2B6D56D9E9CA097085D2C9E68963EA';
wwv_flow_api.g_varchar2_table(64) := 'FF9B32C0EAEEDC4365A5CAAF2749DF313D593A999E8C9FED3A59663A9A2A9BCC331BAD5AA6394B92521D33753525F22D3273E640CA003783CCCE99079774819401BEA479352F3BD702785EC2567EA35B0097CFAB79993365805B83ACEAA5205D1E5605F0';
wwv_flow_api.g_varchar2_table(65) := 'C18181E4A82ADE14ADBE870B9B82564912184FE1F19C795315C0DBFAFA6C5382A25AC5B44F33FC24E4736ECE022F20DE957858E2A9713CAE9433552D7438E90AFD4CE845ACEBC46B767AEC21218395366D0196D3FB77F13258C4FB5796878EC79572A32A';
wwv_flow_api.g_varchar2_table(66) := '807910C6D6EB456387597D3D94EDCA6E1B3DABB7855AA1120EB0C115E6BAB2C1D8D9F090EFB7BF11D388795C093D95A90E8B8826D9D70B8CB9F307439FF102FF916C67DBD24A1BD32AC746CAF991B391177DEE87772DFA86E54782C795F0A73A805563A2';
wwv_flow_api.g_varchar2_table(67) := '0177ED1FBA1999B987C8A53CAD121ABF2A175F497FE6659990D72619C5C02CEF0C7B5FFFFEE4DDB99FDA8E2478DBD88EA921AD902E0752E2E9FF03C80596F00A505AD10000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72345354554797152)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/doc.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001F5C494441547801ED5D7B7494C775BFFB92B4AB958484100890010BF33010F308D818E367ECE31C1BD96E4C9CC4499393D875D2A68D7BD2366D7A7A';
wwv_flow_api.g_varchar2_table(7) := '106D4EFB47929EA4E73439A9DD26354610E4E3244E9BE6E5F81530E665631B30D818302F092424ADDEDA577FBFF9BE913EAD5642DA9D855DB203BBF33D66EEDCB9BF7BEFDC99F9F4AD8889148FBB4C90B9AC34EAEBDD1297DCEF478210D3EF10C175B9E2';
wwv_flow_api.g_varchar2_table(8) := 'A4BB7AC793ABA251A973B95C93E2128BB9131A13E195183EFA0E8F1393B3CC44EF8F56575FB7DB7211CB782C1E93A222B7BB25E82F7CE217CB1F3EB13EBECDD328EB63BA3F899CE5E2B9372DA61DE05EBFFD8907633179D2575A5CA668A6AF3A69B1369E';
wwv_flow_api.g_varchar2_table(9) := 'CA541F2F54D31B8DAFB8FFF52D5F6A747DFCF8AD2FD47B5F8CC7A3570AC86901BC5E1ADD8D22D1152F6FAA96787FBD6F524959B8BD330CF3702B6747BB26D0CABEED63642A39EF259649764F2B8CA6A5E98C5537B1CCF0B2AE583C1E8B7ABDBDEE60F1DD';
wwv_flow_api.g_varchar2_table(10) := 'F170A401207FEAA7CB3E0990E58A0159FB4A2D8A89E54097C927FD5703C5F9915037C124B8A43B3CD7D72CFF3CFC9E2EABCB8C963BCBB18CB39CF338B19C3ED7B95596702B058F47225DBEB2E06A00BE79DDFE6D735EBCAD3E72EB8B2F7AE40A882DD202';
wwv_flow_api.g_varchar2_table(11) := 'B871FD41654F7177D4257117C76264CA6629BCECFF905F114F1CC1D540A83BEE2B09DCE88E466C906F03C81B731EE4B40096C66B09A2B8621EC69F760C9AE84359225B1379556C23EA8ABBC2A19EA8B7A4783541BE7FCFD65A5A3287A15CB6E4F400B62D';
wwv_flow_api.g_varchar2_table(12) := '183EDA9293C256619EAD8826F065F10A88E32E3744812CDCD90D9003AB63EEE8967B5FDF7C0D02AF682E839C1EC0B261B8C072095B27E76AAC8576327E00CCB4645F4970A53BEEDE5CB777DBDC5C06394D809D52CAE1637B1E6F4F8D18BC01E46E80EC5F';
wwv_flow_api.g_varchar2_table(13) := '29AE6843DDDE4D390BB239806DEBCD49231E192D5B2077C2928304D9B3B56EFFA6F9B968C9E60056E32FBD5C0E266DC1C359B7DC7517DD756085443D5BD7ED6958906B209B0338274DD74674A4056BA82D9069C92581A558E1DC926B209B03588B249772';
wwv_flow_api.g_varchar2_table(14) := '4C80554A6EC1BA274320072D90EFD9BB75A1B2E4C6EC9F42990398B2CA35FF8C858E71260B64BA6B80EC71C57EFCC0FEAD8B1B3F8E295496836C0E604A6ADCF21AA758335D6C620A3964C9258125B1586CCB3D3900B23980092E049653184F9C597B0A85';
wwv_flow_api.g_varchar2_table(15) := '15AFE2C0627724FB41360730AD01029B985164DA443342DFCD6D8E3002AF8292C0622F2CF9DE7D9BAE1B74D77C70208B923966266E0DD92386D1A3E8E43C62C50B9B2AEE70574FC41B0C2CF688774BDDEE2DCB14C8D7627D3E8B404E13E08D4302A0E9E6';
wwv_flow_api.g_varchar2_table(16) := 'AAF98E1D450FF5D171047DA64A7B60C9116F897F21206FA87B23FB404E13E00D435D6677F9C985A41551E7A9F36C811CEA89F84A030B241A6F58B767D3725A72FD06C8260B2C394D801D92A1B0D217988360060FB5225A8F92A5DB1077C0952563316481';
wwv_flow_api.g_varchar2_table(17) := 'CBEDD9B2EEF5A757D6BB5CB17A607CB9414EEB919D1192D1821B71235B2F1863D8B264B86B58F23C6C393600E44FD5BB3EBDBB3E1E77D7F34992FAFA644F10665C30E62C38E3AC66B081890659C959B12C99EE3A583CD785ADC675BB2EBF25E701265829';
wwv_flow_api.g_varchar2_table(18) := '0459C93186B3D6EE3A18B8C6E5756FBEFF8DCDABEA5DF597CD5D1B07D898D31B458219B96CC682356B8320630A750D1E25DE7AEFBE86D5970B64E300E74A9CA5D150B9390BD66415C811354F2E9E0321375C2E908D03AC7B9853B9590BD65D57819705B2';
wwv_flow_api.g_varchar2_table(19) := '7F3641BE6FD7A61B2FB5259B0338177DF3F8B60B3560A9E436C8BD116FB17FB6783D0DF7EDDDB296202B6297609E6C0EE05C9A076BA8C6BF5DA86BA4925B2077F7463C41FFACB82BBEB96EDFE69BF5B4A93E9ED9B56B7300B3EBB966C5972E60705A720D';
wwv_flow_api.g_varchar2_table(20) := '04F5F47DFBB7AC25C8F5B2219E4990CD01CC2E40603985F1A5657618C8F108FE4C6657C32D9CA26512647300D31AD0854B67147419399754741DEDEE0D7B83FE1A97571AD6ED6DB83D93209B0338E7640D862F8F367205DC6B833C1D61C0A675FB9D20C7';
wwv_flow_api.g_varchar2_table(21) := '8D629226B18DC361BD3C021BCEC344CEB48BCECC34692C4E14C8912E5872B17FBA2B2A9BEEDDB7E50ECB920563B23990D30478C35027282C2DB0A1ABD97D34384DC2019473987EF284F7556E77431F0FE63C40D274EC53AB0E4E743955865FF6F695558E';
wwv_flow_api.g_varchar2_table(22) := 'D2F246BA7B14C8F80BB74DEBF63C7D9702193B51EBB76DF3B046BA294D801DCD3B3BE3B89C1B877094FCEFB464A5B0F852B9DD0B7D3C98F300494FB7EC53AB0E4E743955865FF6BB4C743955C2E50B77619E1C0C548BDBFD74DDDE86BB59927BCA26B61A';
wwv_flow_api.g_varchar2_table(23) := 'CD014CAE8618E759F626CB82147F8415EF1489112397C71D73B9F997868E0FA2DC61E76E3CADA3AEE93CF1BEE37CD4BA2833780F7FE2E67679A23DBD0305C1C01497C7F5A307F66F5320ABB9B253E95290A8D9FDE01418B82C55A88800194296482CE6E9';
wwv_flow_api.g_varchar2_table(24) := 'EEEAED7349ACCB817B025B768584ABD6A9BEA7F3C442A35D6739DCA37BA776217775F674B9BC9EA9D181C8BFDEF8FC0FDEDD71C76347F9DC355F93914875BCE77F9800DBB2A5E8C3F178613812F6484F3F5E0CC447E9707174A4C72BD7899703C8F178DC';
wwv_flow_api.g_varchar2_table(25) := '079EA250BC856E976B26881CD56F51983841AB86718029B49C4996F1B8A4D0E75356D4D36F59945BF78248EBE364BDD2F775EE2C93EC5AB2FB43E5D44B127C5EC10B6122D0B688B374AAC76902BC7144BB43EC8EB8957D17881D198EE11B8295008E35C8';
wwv_flow_api.g_varchar2_table(26) := '749B174B839DB5CB0E9EB3E245EA0F961D2A877820062F82E8998DDB4174E381A10217E327C9FD3483AC0D4948E6D825253EB86606333E8F4BFC059033FEC562D65B47787DB40F5174DE6394EC3C1FEB38B12ECAC6D4EB4212F05CBF88AA90724A136047';
wwv_flow_api.g_varchar2_table(27) := 'BB097C39EEE4CE2145494BF617E231397448CF6F73A7072338350730859396AE8DE0EDF25DB88240360730E1B812AC58ABD51502B23980092E2CF84AC2580A2EADBB1E4F5CA7F56FBCB93980E99E396C8DB7E55C28C7CE5C424BCEC4906F0EE05C002C55';
wwv_flow_api.g_varchar2_table(28) := '1E95251721F082B8328142AA7C8DA35E9A006F1CDEC41565BE8EAEB15F0439C0E83AB7404E13E00D4352E0E07B450DC0435D5347B45C1F161F720CE434017608815ACECF959CD8BF8C836C5688E60026B057B2056BC5A5FCBD99B464B342340BB016C21F';
wwv_flow_api.g_varchar2_table(29) := '42CEE83A07DC751EE05495916372462D3955C686D7CB033C5C1E133FCB7290F3004F1CD2913534C81E8833CBE6C9798047C295DA1546D7DC85CA3290F300A706E7C85A7A0A9565209B03D86C743F5280B970250B413607303B974FD6624F16B96B7300E7';
wwv_flow_api.g_varchar2_table(30) := 'C11D9280B664CE932FF3989C07780816B34704390BA26BE300E78762879E4C10E4ECDEF0B7FB951F8A1D00F35081CC654DEC275FC45D67620A6DDC8213BA973F552003652F44EDBF38C8A6059607D8B44447A3474BF641DCE3B0E4D148A4723D0F702A52';
wwv_flow_api.g_varchar2_table(31) := '4BB58EFA456A827CE9A2EB3CC0A982954A3D46A06A4CE67EF2A571D7798053012ADD3A97D0928D039C9F268D037D0A4981AC2D193942E8FC34691CB2CB99228320EB31193F368EBF3E33FDD893390BCE9BEEC4754B83CCF931032FAE7C116483C91CC066';
wwv_flow_api.g_varchar2_table(32) := 'F932D8C52C27A50D83F3E4621B64832B1EE600D68C66B93CB3963D1A88B6640F2C396CE40FFCD51B29CCF4396FC1E9CBD1097209A6512A6D488B2E1649F329AB24A0412E30E35CCD50714828EFA91DC248E5900234E80D8D5B3079D320F3D8E2D5C9B1B3';
wwv_flow_api.g_varchar2_table(33) := '07D6315F89C1A4EBA993097C59AF4FB7EA6B1ABA6D9EEB6B1320A9F8268DC4FA9A2E69D13AAC735D52E723EBB1BC4EC9EA0C6B27158635F184DC38C09A3E3B5100F11462F64E7E87BAAE4B30C7BB4E7087E14404916314C7046BBC6E8565118E48317E7B';
wwv_flow_api.g_varchar2_table(34) := '9D79148DA8974E9206DA259D01D0ED57AD8F0F68F2C944DE0BEC9587A823AAD574D9766F3C265E94F3A37D5267DBBAAFBDA813B1CF49CF99589EF4D9778D659FE233A6DFADE32C9ED6714600A69028F0F378D5D361BEEE49BD835377C5E6574B1242AC45';
wwv_flow_api.g_varchar2_table(35) := '87CB5D1E051405D807C1F1D56E0935EC8A43CA42602328FB4EB45F9A62495E06075A8BF052E62AB74FC210E68043A083C41C0704AD08AD7A51EF02F8DE1F0DA331CDA8A3200E4BD1F642D06D05A7EF44500E755462791C2F73170078BC490F1779875498';
wwv_flow_api.g_varchar2_table(36) := '532E47A303724AC965A84E2D6855B93D4AC151C458CA08C0D4E77E74749ECF2FB7792932AB83C3B8468FF15228E9C20F0B9D8D0DC85E80148AF4410A1EB9D153A004DD9704100A8A4CD37276A23CCBDC5350220B0A4BA5D2EB97A0C787B582B874408867';
wwv_flow_api.g_varchar2_table(37) := '07BA64677F87BC10E9910F812695A877149AE4910AD30AC1BF151990799E42F9BCBF52A617144B39FA5088BA612853572C2C6DE15E3911EE96B7C23DB2C41B903B8BFCF0143185317F419AE50EE37E17948E1E8CAA479990F71EF0B6D2572CF78326BD16';
wwv_flow_api.g_varchar2_table(38) := 'FF15807673B44F8E447AC56F974366249903D8564666743F3B63FDF2B9D25A5957B55059042D4D8FB59A7376AE0F420845FAA563A0473EE86B97ED9D67E587BDAD3207C2BE0A5A4D00B5F633C72BE994EBDB01817CA668B2DC533E47169654490580F0B9';
wwv_flow_api.g_varchar2_table(39) := 'BD680B2FE6C53FB6D707A04EF775C8AEF653F29F1DC7E520405F08A0E9B29D34297CF2FC32146611EE7F6BF27C59513A5D6AFC9324E02DC45EBD47B97CBC6A50D18D2A9EFB646BD3DBD23CD02D5FAA592565BE22E98F46309525C422CFE2DEE3AD476435';
wwv_flow_api.g_varchar2_table(40) := 'E869FA1F4039164009FF6AE64A9913982CBDE0A7083C77227FEACC1BB20DCA78ABD70725B4AC1D59DAC91CC094989D14D6104629845355543A0830BBCE7147277D648904560FEBB9B57FAE7CB4E3943C71FE90EC8685D0F23420049796B23B1E916F56CC';
wwv_flow_api.g_varchar2_table(41) := '53CA33C35F0600DC128527A0E5EA540450D8FE347FA92C289926D7954E93EF9DDD2FCFF787640968D25DB334854FBA2F4361BE1098229F9DBA44AE45D900CA3045D11E8165A217C6AB67C503EBAE2C2A91A5C1A9F247A776CA27FA3B655EE95419804B67';
wwv_flow_api.g_varchar2_table(42) := 'C94278915B2AAE96DB42A7E41894660E6871D8391E8FCAD726CD92EB26CD548A188DFBA5004AFC7EEBFBF2DB9E73B20460D3DAD99C92211B4D3399033891117038004DA796D2AA2238E6F84A2BE35B5E99D4377A33808EC720002F5CD574004650AE82F5';
wwv_flow_api.g_varchar2_table(43) := '7CE7F41EF9352C70310444D1513976C30ABE37E55AF958F587A454594D58062211D0F5C07AB0608F7F5A3803B028D6A195AC9E3C07801749FCE44ED90DD73D1B8225C8CA72313C3C1E9C2E8FCDFCB0CC2E9EAC78ED03DF4C05A84BBA5A31499B1F82A990';
wwv_flow_api.g_varchar2_table(44) := '00803F6C7E4BF13DA3A84C7A502F8CBECE029DBAD299F297AD87E56A943F03E5BDAFA04C6E995CABEA87067AE11D0AE458778B3CD1B45F764199EF80EBEE843C6CF1A056FA297300833702EA01B8CCE9E628FC235DE72414EE83E03CE287F08218A7A714';
wwv_flow_api.g_varchar2_table(45) := '0695D6D3C585A351A5104BA1E57F0A419D3AF92AC6A7B0CC84553C8F31AABE6C8E3C50BD444A609D3D70EDA45D847BED1C17BB2F480B045508DA74AF33F0E158DD07E1FAF096FCC565D5F2679165F2E5933B20C8A84C46FBBF07409FF54F963F99B942AE';
wwv_flow_api.g_varchar2_table(46) := '06283D70EB04B310F7187435F575CA5928591BCAB12F65B0DE69B0DE4A7826022F70B94F6148B9FDC2097960FA122813023AD0A60758533E5BD6769C94D300FD1C687E0C565D132887724414CF8CB2775C388EFA2D720BC6F22E28395E1D8DABE6524601';
wwv_flow_api.g_varchar2_table(47) := '26A78A59E572106CA0033F6D3E24FF143A8140AA487C00671AAC6A75F154B9B3F21A584F85D27E355E430874659FEEBA5ABE78FEA01442DA1FF105E581A9D7CA24D4A1A550E0B4FA83A126D9D4F496BC0241B7A10D3AD75A94F9638CA51FA99AA72C7800';
wwv_flow_api.g_varchar2_table(48) := '20BBA130CB40F391D01CF9EA8523F261803F17CAF199AA4532A7B872105C2A4C0794F0859677E5E76DC7E40894E63C40A3B294A1CD05BE80AC09564B083C2C07A0AD1832365D784F96C0B52FC4704025A515D7062B655DE90CF99B9683F2B9E26A595331';
wwv_flow_api.g_varchar2_table(49) := '474D28A8E854F803A1B3F204C669FC4CA99213158B51B62534332073083293B45F1C831AC1267882CED3828E4140CFC33A1E6F3920DF38B15D0E779E53AED68A44A3CACA574EAA91BBE0BADE84F57E0CE3D72C5A00C0627374CBC77A5AE51B70BBFF163A';
wwv_flow_api.g_varchar2_table(50) := '89313C2AE5B8CE97C6BE0C37FCC933BBE59596A3CA22394C50E81C9BD756CC92EB61897B30EE3E5432433E54361D6378140A68592EC1DD7CFA7579F8CC1EF90902BF1EDCAB24B8A0CBC8782BAEFD79CB21D9DAF1819A2B5FED2E94E70742F2EB96F7A413';
wwv_flow_api.g_varchar2_table(51) := '5E85D6AFAC18E0AF05CF02656630380D563F8021866E9F6DFCEFF923B23DDC2535B07646F73A16519D435B2692398095A926B094003A4FE93ECB602153D1C95A746C095CEDEDDEA06C4190D1002BBC80689A0260A2D0A7615C5B822910A74FD795542B50';
wwv_flow_api.g_varchar2_table(52) := '09042DA017AEFB37B0B29FC172EFC254A90A7403285782CF4D709D9CF63CD5F28E34C3CDB23C1303B1E970DD4B419769152C2CE82B54F1028335BAE5575A8FCA5F63EC5C0625B81974AA3C5ED0F248109F196883533F4EE5E829589E63F90A80F84D44EA';
wwv_flow_api.g_varchar2_table(53) := '6F779C513106C1A232734CFFF6E479B0EEE96ACC56F1073CD7BEF693528FF23778FC08C086E20690339ACC019C00A672334940A79BEEC087AB40DDF88400225EDC2B2B20C8ADDDCD6A8CE6B84A722CCBB1B61A16BC0A1F8E7D56822B0378ADFD5DF2DBCE';
wwv_flow_api.g_varchar2_table(54) := '33321FC255F4408BC1581FC4DE0E0FB11C20FC1451F3510432648554A91C41D09C0FA5990D006BFCE5FCD50615E4312E20CDDFB49F4061974C810572C183AB5204919F1ED0E558497A7A958EA37629EAB2ECB32D87E53C6814422918581621AFAB5A8069';
wwv_flow_api.g_varchar2_table(55) := '5C40597521689EEDED90CDF000EC4D11FAA157BC9288CBEA6E1ADFE6001E27777A2ECC9C8D73D588E0F8611DA760914D7D21A5F96E749C2409B61FD1E60258282D9B5316D6E5BDF39883BE03D75D620B492B06AD870AA25C1E00398F698CAA075A1CFF7C';
wwv_flow_api.g_varchar2_table(56) := '28CF717C6941508A0136175CAC1A2E0454213904F73E1FE322A7367CAB30F9243D4D93E79CCEE81D5BB6C33EAC85A2FD7BD759D989808B8B1DEC03199D8620926D92BF3EF4F177ADEF49038696E550B05ED53688652891573389BD77262D11E7B524C75A';
wwv_flow_api.g_varchar2_table(57) := '2F2C46B00285318CD3260A4DCF3F397E5601082B12B789A0623B22DBF72148066BC993759DAE9CDE4097629B8C566702645A18DDB69EBA7580E6715862103409A205FC48EA89DDA3AB66AA8512FE57EB3BF241CF05F06BF50A3FFCA1E8D3EB1CE93A2FDF';
wwv_flow_api.g_varchar2_table(58) := '4160B50CDE452B88553333DFE600A6D4345AE435F17C9CFC134C05AEA33CC1F124889A9678F16495495696D70A4193ED69C635CB7AFDF8E2F4879720252ECA14AA1E6875B2CA5059499FC34035DC34972C875A1E4EC7E4993980C9D5F03E8D8B4F6D09DC';
wwv_flow_api.g_varchar2_table(59) := '4912089BEBBE1402173E6855140CDD5A07A24FE7AE0EEF95C2C5CD421DFC72CA986D716EAA5DBE2A88E211586927C648352503E3143F79298665D5C0BA35006311D6AD326758C89DAB53F83C3A7511A2FD0A3506B33E972F99B8DA363738451E9BB2109B';
wwv_flow_api.g_varchar2_table(60) := '305828414A0A8026AC4AA4F795947E7A24EDDA1AB93188B11F0487DB67ED1036C7242E4ED082D59C10D7B948710E0BF71FE0C3A0C51A7F2D30B840C2008BC11A2DDC0A7D869C87729B00ABB2B0448D7F6A1C46B901CC5B9B10AD73819FEE9B63A3754FA4';
wwv_flow_api.g_varchar2_table(61) := '1A81DC7CCC73DFC5305188F6B921C0C46FFD512E1DE76C5327064BAF467B65E3A4D9B2AA7C96CD27FB17C37A7848292B95D683B66EC47CF82B989EBD82E1807DB75AD094900F91755C4CED3073008FC20FFA87C4050AECB7A227E518B3DCE8E10108E741';
wwv_flow_api.g_varchar2_table(62) := '4C59A8E174C9942BDDE73904486F2212DE0740B85A65D5B7A63B9500F80E4C9D0E01A820CA16812E3BC405894900F6109620EF4570760D161CD82CAD9402EE0CF7CBBEBE3639090187144DA814AE739ECCB5F3DBB0C4188662119C0AF0472069A1A44BB7';
wwv_flow_api.g_varchar2_table(63) := '5E020FA3D7C5A95401B4CD2DC03B0B4AA56ECA02B524DA6FCF779B01EE4F9A0F4A37EE73DECED53A6E8C3C884D98B9F0166D68877220C8067105352B5D7280959B85757017A91D96F402A2E0E7C39DF2E5921AAC522D42548B8D00DC2310B440AE52FD1E';
wwv_flow_api.g_varchar2_table(64) := 'D6DB04811DEC6C560111DD2DC108604E7A3756C0EE2E2A975F62A1815318D6A182FC0A5B842D38FB02DC613540A3F5538404F23822D8DF0D74CA3E08FD6877AB4513F7E8AE19EDDE31E51AF9BB4973E425F075004AC00D0E4E650838A742BFC3CAD62B50';
wwv_flow_api.g_varchar2_table(65) := '2AFE1E1EC75BDE3F81B61F01B8B550502A07BD02F9D885F9EED731A77E07BCABA81A746228CB0D8DC72BE6CA1B50422A4BA652E6001EE177AC2EE8C8B11D0208606C7CB8A8427E3075A97CE5AA1B06D76969699C1A9DEC69939F5C382AA5100037D77FD1';
wwv_flow_api.g_varchar2_table(66) := '7E4CCD313946B30C41E312637DCD6AF98BD2ABA40D345F83CB7D1782BDBFB04C9E997EBDDC54594B581578ACD785B5E65F61212380FA780A595EC26A542BA65B9CB7922657C9AAE0191EC5C6C3F7C1D74AB8F7D350945DA0FB3680F1A1DC63585AFD11EE';
wwv_flow_api.g_varchar2_table(67) := '7D1A4AC0E1610794E06BA535CAF55231C3186B39DF3D8E48FA67EDC7E13A62F27F68B30D8AC1A91E15D88FFB7754CE9587B00EBE1BCAC245193DC4800D6329736BD1094A49E6A9D5744D7761D98E810777962AE1AE389652F8FD102213E7A65CD16AC4CA';
wwv_flow_api.g_varchar2_table(68) := '56035CE9CD189B69994FF55E90D558DEFBC48CA56A3990DB8B5C9FE226C25761A5EB2150EE02717D7A2A76A4ACF19CBB5AD86CC035FAF7EDD89AFB4EE769590A01CF46DDEF6271E57A5CABAB5EACCA7089919B015331163F84766EC278D982850BAEAAD1';
wwv_flow_api.g_varchar2_table(69) := '020BB15F5B8D4592C9E0F9652C83BE7EFE6DB919AEF90158EF64F485EDD31513C41700EA73F014376023E1BFBB9AE456EC4BDF36659E5238F2C48D87872B17C88F4FBF867934940777F8D811326329730083458EA36A7A0086196030789A5F325501AD7B';
wwv_flow_api.g_varchar2_table(70) := 'C0FE50780497DACDB92E171B7E7C66BFFC03B4FF06355FB4547A0540F917CC312BB12A7467D57CF1E31E053A108D41B801A5285A3EDA1A1924D19A80ADBCDA7A5CBED5FCA658211076BAD0F60270F55D6C664C4660456BF760D7898AC3C89D4A518BA5C6';
wwv_flow_api.g_varchar2_table(71) := '5A78099D94A2E2847F61C27156F0F92C5C2DFB45D03804F9F1E0FADBD84868C48A582D94A204FD6AC550F41C1638B864495E19DC715EBCBCBC46BE1E3A2DFFDC714C6EC7664AB76EC8506ED6455B3858ACE19841125D1F17DFD507C704D9465EE57C5C8B';
wwv_flow_api.g_varchar2_table(72) := '965C80F1B413EE7347EB31F9F6F1EDF2B76D47E57A5C6780C3E5478EA08C38CB70FEF7675F9767CFBC292D70AD74E5DCFDE178470173FA63E5D8ACC06A149FC8E8C238F74BEC626D38BD4BCE42212A4197632A9F16A9C27133AEFD2336167ED174003B44';
wwv_flow_api.g_varchar2_table(73) := 'FDA0E953CAC3EE90960AB8EC9CCAC8E405881C7B1F2B9D2D1F9DBA502DA9D23D738FBA17657F0B305F411CC0392F57B9A89CFFD1D322BBDA4E282566AC41439D8621E0A1698BA5AEB05CDE63DBA041C33095CC5A303946B2A6276E69C3D8720AEBAEEC38';
wwv_flow_api.g_varchar2_table(74) := '35DBBE6D1552E5AC71B41B3B2BC77BDBE58DAE66F99F9E66791BDABD06D6495FC5F55FA51438E331A3E30EB8B3CF6393FD2BDDE7E42370F7736161748F6AFEAC6A714E1A9366B85606542F41A8DF875B9E0C7A3510B47ED68BDACD633E1AD48436BF7876';
wwv_flow_api.g_varchar2_table(75) := '9F3C4A57AA76AD2A86D1445195386DEB04DD53880F76E2F1A29BCA66A2ADA8BC87608D5E8373EE439D4DF21CDAE37227DBE04E1195B30AC7CFB5BDAF1E06E0D0C488DA87A1AA1060AF094EC3BD776536CA0CFE36268ED34D89329F183DFED63C7E5CF986';
wwv_flow_api.g_varchar2_table(76) := '579F5C8380F825FCF6AD27168DC6D02937E7B79500690A2C888D24534ABACF1004D60CCDDD4B77075016C1A22A21188269C5BDC359221D52E402FF6BB0BC0A007E3B1FBAC3A71CD6C325480E077CCEEB5D8C7FBF4774FD01DA588EA71C3995D2E03AA992';
wwv_flow_api.g_varchar2_table(77) := '261F0D64C0B4170F00CE40FB37629D7A1EACAB1CF36CFDA4082DB91D748F22AADF0DDA41D45986F198411CBD8CB55FE5923370C717A030DC8CD0FDD632E0C3883558CCA9806CD463C228C0F9361FE63B16E989793C5EB72B8A0D658FDCB273F523DB61CE';
wwv_flow_api.g_varchar2_table(78) := '4AC64E7E27726CD682ED96D929AE0F9F01707CAE8A40B1F3BAB37631750D3F058988D62D2BE94EA1CDB47E6A3C5332EDE3352E07D2366E81F043B09E1701E233FDEDAA8E55CBAA5F8632B330A6CF4639D24D062E2B9126EFD1CA6E4659EE44BD80B97763';
wwv_flow_api.g_varchar2_table(79) := '129A2C5F01BAD341977CBF88BDE1D3500CEC49A97E92B7D9B857464563613BF198D65C04B91C80829C85820450879C86F05D8BF2E5A84766A0038A27BB6A5A9959801D88B043DCE559C2BF941B33A1120662FC60AE12323BEC2093B426EF730CE5948BFB';
wwv_flow_api.g_varchar2_table(80) := 'B48B2018063D83D30C5CA75BE787D7F4437B63D1E53D7A0DE604A71C7CB30FE487AE978996CAFB048A5758BEC6E59339BC681551CC3312A6453B932EC27C06DC788D5D85E74C2CCF3E91B6C9641660479FC8382D974C8F9D203E146179FD19BBBC75570B';
wwv_flow_api.g_varchar2_table(81) := '8642E67F5D97395BB4FE4A824743F7D4C9185F9A261582C94993E7049A77ACBBD67DF62FAC2F5885F8ADEAAA83842F16D5F49DB7ACB66C0E3423CE02291E9B05188C25F296789E8CCFF19449568FD79C759DC24FBC375AFD64D7C7A2998CAEB37C327A89';
wwv_flow_api.g_varchar2_table(82) := 'D7462B4FFE47BB974863BCE7663D02382493F994A6040C0AD12CC0503FD31A98A6A872AAFAA0EC060FD267DF1CC0365306952FFDDEE518854CC8CE1CC099E02EC700CA4676CD019C8DBDCBF394EEB46BE37011E6AD78B83C5239A30C0DCA313D0B6EBCD6';
wwv_flow_api.g_varchar2_table(83) := '1A79B9CBC7451983C1412AB2B922EA68195A3BA7228D8DFA4A4ADD4B0FE0F50795AEC5DD510B5E839A97526FAE844AB60C954CD91F5BC6A9762D2D80D7DB16EC8A7960BD588FC27FAC3A92C5FC27051928D9A965BD785CC994F86A2F9922C2E9AD64ADB7';
wwv_flow_api.g_varchar2_table(84) := '5AC503ADEF63E7F6B0B7B47851B8BDD35A12D68E455B35CF79ECCC13997696E53D5D5E974B3CD7D775597DEE6C3BD9B12E9F8C17DD46222FBA0EF364F5F47D7D4F9763CEA4E95A6743E7FABA95C720430F6478187B51EFABA2B68C75B589E6BAFB13AD67';
wwv_flow_api.g_varchar2_table(85) := '9587A261BB5089E2FA979F78107B754F82C1B2119D498DFA1F562D1BE848A8BB036EF091D7D63CFA8C128043C6A908243D80D9A28381D53B9E5C859DCC3A3CB93809CF0E725F1829611418D470BD8166E7FABAE648A98D223064313C55E5C6A86B0B4A29';
wwv_flow_api.g_varchar2_table(86) := 'D960799B8ECA745DE7351CEBF6F5E5C4737D9DB9E6D1796D347E9D659C7507CBF32FA348D2EDC6E34DED7819C5CF77AE7DEC3555CD21DB443297F69C8CE49359091892E9FF03A6656305C15E826E0000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72345765775797154)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/docx.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000016F1494441547801ED5DD98F1CC77DAE3EE6DA8B4B521245EA3049DDA2021FB204C809122BF28383007E32F9903CE7216F318C3C0409A00D029B6284';
wwv_flow_api.g_varchar2_table(7) := '387F805E8240241D6D90870079081C438A11C9881358162D2AA42C1EE225DEDC9D9DDDB9FAC8F755754DF7CCCE9233D3B5333DCBA9C56CF55457FDAAEAF7FDAEAAEAED15C2400A436119203352120BE182BD15E6D1C9C4D4C0846168218524FCC1E9EFBD';
wwv_flow_api.g_varchar2_table(8) := '1CFAD67750328FAF416AE29DA335F9DD1201C65E74ACFCCD6DF999B79EDFFF579F87E13B8E108702CB12723E26BB1B152D374DC749707F76F2FBDF8506BC35375F9C2777D681BBAE20EAB99395C97A9A50B73A9D6524D7D9569725EBB24EEB3B4C4F9817';
wwv_flow_api.g_varchar2_table(9) := '5E23F7E2FF9D3BFCA79675E8FCBBEF2EB861B8E06F1590932C213BFA4A6178D0B1AC45FF679FFCD96EC7727E32BF63EAC0D2ADD5666809DB02B7C947CDCF8D3BD2B5D8B5BA0E91ABF63A8FB1D3B575CDCE3B1BB78D5BAA2B989D300C726EB1BA6D7AC76C';
wwv_flow_api.g_varchar2_table(10) := 'B3E9FFDC0D833F7A6EDF5F4890BFF9CDAD01B2DD17A21D951717A38240EC0726CF9497AA42812B403704C8615BCEB2F51F555795EB769D79DCAE9D663F6D755D0A1FAF297B212C58289A4DAF323F5F7AC513D6D153E7DFDCF7EAAB0BDE7BEF2D385BC127';
wwv_flow_api.g_varchar2_table(11) := '73A203A783070F5019C031C70AF18344CD03E3C6E1130D55580E0DC6F252359C9D2B7EA319065B0AE454002F2E9E9496D7716C282E111E585646D730A00E0B44D0A1552ED77C80FC0A41FEF585BF7D829A2CC43BF2DEE80698AEE754006B0DE610E0FB54';
wwv_flow_api.g_varchar2_table(12) := '289D6E3C43690DD31B2770008219DA2A6A00C85509B2F083E31F9EF99BA71078F9422C8E2DC8A9008EB94487C69FF1489D9646FA5A800E25A67F8E402EBDE4DAB9A3272F1E7E729C413606705229C603E67894D4604AA7CC1952B4402EBE1478D6B17690';
wwv_flow_api.g_varchar2_table(13) := 'C7468EE5048D013C2EDA1BC31A5F7589962390A54F26C83F3E75F6C8334A93C7CB271B0398EBCF714D91E6760E3F09F28B4D2BFCF189733F7C76DCCCB53180C7C703CBA8B90DCC2E1AACEF2741FE8A259CE3E306B23180C7497FDBDC0996491B68701BC8';
wwv_flow_api.g_varchar2_table(14) := '2B5C42CD16BE6203E45F9F3FF21C3579710CA26B6300AFD70BCD9F8CE7BD7180B5AC954ACD9F01C808B7FFE9930B6FBE70680C40EE6D7A3D61D4A6173DB51859A5C1CC8DCD58BBBC2203AFDFF283E0F8479FFD20F3201B04786470F5DFF1E0B218FBE4D9';
wwv_flow_api.g_varchar2_table(15) := 'C20B966DC7202F1ECAE46688318007E759FFF8A46E319806EB6E6390E74A2FD8AE7DFC9767DFF8F2A1438BFE22405E585830C653DD619A3C5383493391BEDA7648E35DA2E88DC81264BB52A979B3B3A51772B638FEABF387BF4A909F7FFEA49525908D01';
wwv_flow_api.g_varchar2_table(16) := '9C4E2936E2E310CAEF1D456F3408EE7F392BCB04B9F89C1D8A6327330872AA273A9233EF508AE4ADEC5D531AF580D3893897FF4E1920CF6D2B3D8B838A631FFDE6077FFCE5A7FEF297617800941768B22142A34BE9A69718F758ED64697039FE34EC5766';
wwv_flow_api.g_varchar2_table(17) := '8BC7E05293E7E64ACFDAAE73ECE333875FB2AC85E0F5D701F1887DB23180639548A09ED14BF8DC38A5E1402C282D4DC679F2333818CF0CC869A6173369CCAEA0716D698020ABAD7DF4456A32CDF5ECB6E29338933A9A054D36067007CFBA3120B365F7D8';
wwv_flow_api.g_varchar2_table(18) := 'AAEC67DC2D90A7678B4F11E45F9D3DF2F228CDB53180FBE142D6EA1AD2603D2DE593CB358F20E369A6E327CEFFF09551816C0CE0B10AB23414516E508335E516C83333453C716A1F3B71FECD91806C0CE02D7A5CA8011B246F818C75F25E11FA2301D918';
wwv_flow_api.g_varchar2_table(19) := 'C0C9C074106E0CB34D5BBC30F846472F439620AB1DAFE25E2BF08E9F3CF3C6EFD05CB331FF1EAA172269EA18EC609C204EB0CC20071254939772C78B20CFCC95BE14D8D6B11367DFF85DB901F2D77CD06F73413638BD36BD484E307BD7C39745B5AD89C0';
wwv_flow_api.g_varchar2_table(20) := '6B66A6F018D4FAED16C8E2753C92BD79201B04788C8EFC47238BCA27AF10E43C400E25C82884B86D1EC8C60026CF46C3B7EC1988BB8C2802B9EE4DCF141FB36C71F4E3F3475E55202F6C8A261B03788CF4F72EFC1FCA2D09F26AA5DEC412EA51F0ED6D9C';
wwv_flow_api.g_varchar2_table(21) := '42FDBE5AAA99D7646300CB27C787C21FF39D18DEE8E865803076965B59A935A1C97B8250BCFDD19923AF6D86261B03789CCD33C60EF3A87061263FF8C5B2D687E5C9EF9DD7FABECE93F7A332802ABB91BFF887B642B8785A939ABCDB71C27F3CF1F9E16F';
wwv_flow_api.g_varchar2_table(22) := '5193B98C7AE79D8378DB40FA640CE0B1DCC9020851A2D924CACC642CC18BB60FCB3BCB92DFF57D9D77B9871E147DDC8B12FBCDAD20F0A2265B8175F4E4B9C3DFE63D3E1D62E2A8D118C08A2D7ADC19CF35B00C60219978780EEFE5C0A1AE6363996AE32F';
wwv_flow_api.g_varchar2_table(23) := 'D787F8B1D197ED386B957A038FFF3C84C1FCC3A98B3F922073AD0C6D8FC56100B61A7BA26380BE47D7042CA39924A87EE83915A85020C2CAE806A47A5EAEAC545CD7D9D56C783FFAE9FFFEF96F5EFBFA9B6716170F420917F127AC83256300A712B3C1C6';
wwv_flow_api.g_varchar2_table(24) := '9EAA951A2F1C5EE8156A7EDD595BF5C320A022F30E553C9927BBEA76AF5B59B28DBEDEA85E541E8A1C0C8A0F0BF21CA40F11B638A3FE065BBF2B43D3E93D370670EF5D66A426F08BB4D82A1473390B8BD2EA9A270284B40A648E538941FB887599CE93F5';
wwv_flow_api.g_varchar2_table(25) := '9265EDADD4377D5FE7BA8EFACEF1E473AE68367C4F7821DE2E903E1903781C832C2A2B990A50C35C9EE18823D6563D1112643E184BC56222FFBB5CB34841C34AFDA5756D1521189190D133422F454FBF26A33FEA716D6341D6381D17C6D307271563B97E';
wwv_flow_api.g_varchar2_table(26) := 'B1DCBC6395A6A8CC9605463304531FDCEB760D3A71799FD7EBDA467D488949484DF23519C971F77A6D0C604AE4D8274C2257B00540167C67476B713CEC891964A63180631B366C6E18EE2F2B201B9A9641801376C5D0E0464666D4201B64A54180B78C0E';
wwv_flow_api.g_varchar2_table(27) := '2BB902C8799AEBE9119BEB94526E0C600A9D41C14B392D33CD196133BA1E67908D01BCC5F43796106AF218836C0C6044F93153B6D895DC8000C853D25CE30FFD593026C918C05B175E85A436D753D32E965000199B21E3908C013C8E3B59FD02D406B2B3';
wwv_flow_api.g_varchar2_table(28) := '899A6C50768C01BCF542ACEEF01364579AEB489337C35C1B34870601EECE902D590A90195D4FCD00E4CDD46403CC3306B041A13330ADCD272135192FE7903E39C3201B0378F3599AC11E68AE09F2547635D918C0F74390D555C4123E198FFC646E09650C';
wwv_flow_api.g_varchar2_table(29) := 'E0713D2EEC0A5ABF85F4C9D0E41296505903D918C0FDF264ABD5974BA80C823C01D8A0A46511646300C34A4D12389035908D017CBF2D93EE26CD5902D918C0779BF0FD784F83CC75F22803AF09C09B287D0499EBE45146D7138037116092D69ACC87067A';
wwv_flow_api.g_varchar2_table(30) := 'D6648301CD04E04D063806D9924F86F404B2C1806602F010004E82CC870624C8433A4F3606F07DBB55D98780047879929BB3E493218E3B9C87068C017C5F6F55F608B2FE539961826C0CE01EE738A9060ED03A0F0BE409C0231039C6506D206329C507F9';
wwv_flow_api.g_varchar2_table(31) := '5AB15516A36883631A01CB87DFE53A90E19309BA04B98574FA7119D36083634A3FAB31A1204166E0E5AAC08B39033193C918C0130D1E0C9656E00570A7B184A26F36F948AEB13F009F68F06000EB56DCF172A8C96E4EF85E20FCBA19953106B01EE8241F';
wwv_flow_api.g_varchar2_table(32) := '9C036AEF1A3B5E3339E1E5CDD8EA09C083E3B1292DA5263B788343297A8743CA5E8CF9E094E398348F38405747904DA50C6B70AFB3BC97F7EF46E76E6DD2D6BF1BEDDE604B4F21EEC718C0DDD81277D3CF1529D9580FDECB44B11E77C099D35F315FCF1A';
wwv_flow_api.g_varchar2_table(33) := '4B708A4943C5167CAF18EBAF4FEBEBB326DF68D4AD3E3768493FEE57D136E33FD78FAEFF126300C753EC7F10ED2DB8ABD3C41BE89651AC41EBC65C076FC871A52058560E39DA49E0C8DC78345E50C6F7263E0499746CFC3BA369B44D828EE228F9E12A36';
wwv_flow_api.g_varchar2_table(34) := '1C6A929EEE5FD527AB92E3E04B5A7C8C93F4559F2172DB2AE153ECA81B111F41660C60536327D31C7B5A14EC4780930625068C4CE6B61E852008D7841FAC082FB82D01B1ED59E49C92CF5AB2AC98DB0B86E7501F20901EDE2FD644FD00EDD71F900422EF';
wwv_flow_api.g_varchar2_table(35) := '3C84FE67D05A0B4A289AFE2DD4AF4B7A7A9E1426D2CDBBFB5BF42DCBC158CAF2B39EB66E39DC3C63003B606459CCE60F8887E75E03A38BF80EF3287703928C21C078195CB006E65744AD7943AC363E136B8D4F25F88E3D87BC81B78C36C583B3BF27668B';
wwv_flow_api.g_varchar2_table(36) := 'FBB0430440010005E3CAF27F8872F517A03F07A20492DB8435E142401EDEF68702FF5601820340519F027575F93DB1B4F63EE4630ADF296CDC715A11D3C5AF893DF3DF06C079D00DA455B85EFE2F716BF5A7A03D2BDBE2D74853A600A6D42BCD288A426E';
wwv_flow_api.g_varchar2_table(37) := '079854928028F34A203A93D26C82DDF0BF2A566A67C5CDCA7F02F04B68BB0D20DD924015DDED0090EDA1D5006D2AF7A858AEBEDF2246F31E845551709F02B88FA3EFED0A609A733B27A60B7BC512EA2B10191B9056208AB9DD622AFFB02CB7E12E9AC12A';
wwv_flow_api.g_varchar2_table(38) := '846E05BD7898098449FAEE563723B9C814C0CAE32A90A9415253A429A5DF84BF4DF84DD6A5366ACD2900C4C2CC8BA2947B585C59FA37B1D6FC4CB6AFD43F1375EF79005E008834FF3900B95D38F0C37407A449734EC04AB9C724A04D7F55D1651F04D2DD';
wwv_flow_api.g_varchar2_table(39) := '09ED9E077815409E079D26C653029D1DB8F684EFD7F094465154EB5745B5715ED64153D95A69BCFA368ADFDD238D518C047D521F35C864BCFA3098C23B241B5F883BAB9FC0547E0AF37A0E8CBC264120706CE50735C9F899E2E362F7FC1FC03752B3A0D9';
wwv_flow_api.g_varchar2_table(40) := 'DE3569CAA580A0076A6B21B71340C38C23F892C1190023E04568A363911E6C06FAD402958746E79C07418FC11A05D08320CC00E09D513D35C6BA771B7D2DA15D1175A8E5C9D88154879F8C69B0D282F413888CAE2204B4358B6EAF7ED8F26D347F0CC44A';
wwv_flow_api.g_varchar2_table(41) := 'B9BD62E7CCD7C54CF14BA88F373E33AA05D0F4A13BA75E115FC054D7BD2BA2DEBC85BA0FA20EC10985EB4C41001E14CDFA4D2039037F5A06588FB4EA8010AAB22E124CBB0B5751CCED81909D6281EC27E70074771642A57C6F008B536D7E81A87A0DF577';
wwv_flow_api.g_varchar2_table(42) := 'A05E37974282C34DC634D844D448864AA62678A07775A8112122599A471FFEB2E15F1377AAEF890BB7DF86569F92DA26CD2D40669A2D3D0150F6090FF5AA4D6A3BCD31408B002BB8BBD1570335096453029877A8D5CA57377DF8D28816B5BF0480659086';
wwv_flow_api.g_varchar2_table(43) := 'E899E0E5A1D13946DBB0125CAE79FE1AFAB9026ACA4AAC9F094735FC640C601343D7DADAA2850206D04CD45A1B5A8BF7C1E23305D3380306EF8209BE2AAE95FF5DD41A3750C60008112E985E70E74529FFB86CBBD6B808D319AF6D0948D17D0035B97CA2';
wwv_flow_api.g_varchar2_table(44) := '997600E023F0A325D407C488C0950B8050C0A453EB8BB0000CDC788F4017D09E01987A12C382A5B823C7624913DF29A6721823F9952980C99636905110B38AA611EF7286FF53D129731FE67627A2E6CF45B9762662A0D252B9468519E5DAB8D6BC80E5D4';
wwv_flow_api.g_varchar2_table(45) := '0A88731385EB630B7EF8010006138BC897015429B74B8249409BD0C695DAA7D2DC6BADA7C0708D1CC27AA035007F48D6579D86D0DE1B72BD9C25FFCBB11903380622E2F380591B1DBE8D795DA208E80FCD29A71000C46B6A6903EDD262415FCBE0A9E9DF';
wwv_flow_api.g_varchar2_table(46) := 'C0FD1BB2156E4AA1C93BDB1038613914AEC01FEF92805353999A7E59ACD43F46CE7FE3C0BE42192553CBB99C72619AF3009CE5740B8CF86B8D2BF8A6AC81EE1F15469E8C01DCA679034E6B3D0DE5D1D6977776C07FAEB116994F5D1B6DE5D22A87720440';
wwv_flow_api.g_varchar2_table(47) := '88C269BAE5EBFAE987196839BB505681363E8A8089FE940053582810E760766F0334152CD12270DDCB5D325A0DFA6B06588CB6E5660B82399A7A8E784B02DCC9F241BE93BD1A1ED91E0C573FF7A646D32A999B547A00C0F616769AD660A6BDA00A42CAA7';
wwv_flow_api.g_varchar2_table(48) := '72972C2F9739396C7CEC86A6E76527521B610D026876AD7115B95A1AF1A6F6C3D47C0A888A9495FFAD7B5FA01F6CCC4402218965E097310D4EF235CDBCFAA7C31658FAC09FDA58132B062B2D22A00CA2B8F95F4730D6F0B84665D4AC348F1B1539E751AC';
wwv_flow_api.g_varchar2_table(49) := '7F1F9243A6B96DC057D79A97516F5654BDCB323AA6F030E5DD6DD0DC3D72FDCB408BE2C838A0D6BC0E33BD8C7E2824D4F83631C5F7D12563009B981269B4D3E966A215A00A486E0772F99347C4BC5B32B8B53B85254EC35B6E01EC07776464AC4C28198E';
wwv_flow_api.g_varchar2_table(50) := '3D29EC684DE59F0468DB4087C1970058B700F275E15AF3108ACB9286BC016BE24280A6F3FB6504AD2D06D7DDD5C625B4C67A18263A4BE659CD92BF339494064730238B4D34A08186A9A00A4B266C1992A19E7F13203D8D0385FD92C96CD1F28BD8E86062';
wwv_flow_api.g_varchar2_table(51) := '3D025F8566AA5324D209A0BDD368F734A2691CEFD11DC0A4579B57A18D65B924F3FC25007E0D75A351C1A74F17F64130B85E560156D3C36187F4BFD45E550F179949C676B24CCD48411B332A821AAC0B2270D4E1BB2F373D2A58DE3C8D93A76FC975AF1F';
wwv_flow_api.g_varchar2_table(52) := 'F94B0A42A57E1126F61CC0566B5BAE79ABCD8B088856A5A96580E402E0E9C2A372E834B95C4AD51A97655F3C63E6726C0DD1314FA26C1B27467832BD94DF054DE62188DAC1AA79D078987FF6A3AC8A1EB1298EA4A3630CE0189274038A74451169234A13';
wwv_flow_api.g_varchar2_table(53) := '4AA632CF41FB76C25C3E21B72AA70A7B003E8007D3A98D75F8DADBABFF0360AAF83E0FC6D38CE700C4756C5BDE86306C4719F79F8BC276C9027664E17E196D112CC13AB08CEBDD1A8482C79205B9E74D3FBC1DE5CAD0F3F0A28A408C0F09B8F60368A376';
wwv_flow_api.g_varchar2_table(54) := 'D1709199640C605372DBA6C1F802CC24A83BA6BF863DE627A499E6D661CE9905503C52CC83C188742370B924BA5EFE40AC621DABCE64D532874B261FA74134C1B3A57D12006A3AC1A4B925A0B5E64D683177C4705800F06CEC4A714BB4DEBC238582BB6A';
wwv_flow_api.g_varchar2_table(55) := '7CA0402EA7F0C597DB9397152DDC5174D40CB282B031804D4C48B199AC46E29A941F682DBC2A4CE91E00ACCCA9EE8B1AE4070D00C1774516A5065E2FBF8F438977210834CDF4B5D42AE68AF16B088802B491FBCA941E50E735B7206BF4BF7223432D8194';
wwv_flow_api.g_varchar2_table(56) := '502C2BA128EE8DC615B5013DA5F197326B9E3139F97C0BF30C259A4675D04EBF2702155C513B24F0899112580170B8765D59E361FF7F6307EA43B42F0034CA2EC125B06CC9E347172062E90393CB356D6CD60BD2AC330863A20156BD513004CCB0F2CB2E';
wwv_flow_api.g_varchar2_table(57) := '9F3009B859425A0EDADC96669F4787AA0F593D53BF32A5C1529B2073D4229A4B7548CFA72394F611260517D80FEDF57CD4F3F0B84EFD1C3EA701DC1282A119D4E17245831BF39BBEDBC3531E7CF283347D682D133739560122FDAF0A96B42851BB0BD0E0';
wwv_flow_api.g_varchar2_table(58) := '0BA07F290ACEA8FD601BB4BF523F83D65C1EA9A85C12CBD8AF8C014CBF378DC8F51C8E01DF918CA326297863CEB18C4787D4C400018E3C1182DFE4698FD2A4F5E04A20A0758C7EAF977F226E557E0E2A917F96605741AB8AFE79E0CFF64C5C72E5D1CFB2';
wwv_flow_api.g_varchar2_table(59) := 'B874E75F70CDC89AE3519B257CC08EA75AA49DD5640C602DF369274AF3C7E8B7EE639342325341A60D2DE94BC0E5392283A4825CB3AA5202A3F5BCFB4848BF09C01A08A61450AC474DC53FC0923B519DED947835FCABD26A44BDCB3150BB952B3035FBCE';
wwv_flow_api.g_varchar2_table(60) := 'BED37F370670A796A5191A99C6DDA9DE1299AB021FC5FC7B8F446A29345E27B6A030DD4D136D9C416350BA4994EB7E3B8A33F4D518C08A41A66646666B33B911CDA4D690F19DCCDFA81DCBDB4D6A92D2C6ADDADB6C5C2F5B778C01AC03A1E14DAF1F4087';
wwv_flow_api.g_varchar2_table(61) := '37AAACF5A4D6010646452DE84D130C743621D133078C01DCAF91EC7984938AA938600CE089F6A6C261D31A1B037862A0370DA354848D013CFC202BD5BCEF9BC6C600E6326962A6D3CB8D691EA6027871F1646BAD020D0E5B5FD2CFF3BEA5401E265525C9';
wwv_flow_api.g_varchar2_table(62) := 'E34198920AE083070F4881F3FD00C7F0A1254FF70619C5A44D8B038A873C6BC6311A92E671AB429F17A9363AB474E15C3674F0C38370FC50934D5B9A3EA7B519D5956E0D46B9B7B6609AE421B5C5C70FFBD23C1EACDF94E7C1070FAA6EA76C71B66E89D3';
wwv_flow_api.g_varchar2_table(63) := '73F3A5034BB7560322AC832E8E524F2F990F3AE08DDA75F6B3513D5DDE6F7DD58E331834756F1B8F03071E38DE020F9DA5DB6BA7C953F6A4796CB6D71EA941DCF098318685F4FEA9EF7F17D95B7373C5793DE816198D6CABA0E342CF5D37ECCC593D5996';
wwv_flow_api.g_varchar2_table(64) := '6C9EB6ADA6AB69F23B931E7367DE794F568E7EF5DB56F78D5C5F96CBB52550FB93DF7EF6EFFE9954933C8E7AE92BD3ECE9AB51B27272001F9CFEDECBA1EF7C07DE987FB8A39C48B2F2E4BA2B0722B9B011A62E598EFFAFDF78E6EF7FC18A49DE766D38AC';
wwv_flow_api.g_varchar2_table(65) := '42B8DED48232ACB18E4B3FA678FAFFE3880F711CA5E3570000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72346071615797155)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/dw.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001962494441547801ED5D6B6C1CD7753E7766B90F5214A9F7D3D6C37A58925DD972053F1A1B4D8D1A2E50A3681B1930D202355004E8AF02FD653B16C2';
wwv_flow_api.g_varchar2_table(7) := '2628FAAFBFFAA34D5DCBB66A2AB1D2A06DD2C249D3A468ECBA758CC47122BBB6AC17F5A22C5212253E968F99E9F79DBBB3DC5D52A4B83B3BBB4BCD15766767E63ECF77BE73CEBD773812892005129808AA696815414F8F1388B4FC382A8598AABCB0D073';
wwv_flow_api.g_varchar2_table(8) := '826BC4403622A3CF7EF54123C1534120DD38F59D8556166F7E1F7DCF4A3A3720AB36FE9DE9F9E299E0C01B6E70F4801F8E27DEEED4A7B59A34B61CDCAF7DC104FE4BD94CAE4B08774D35D767B0336AF57D91F60EC97776BD29A9B63FC9F53C731A4C4E49';
wwv_flow_api.g_varchar2_table(9) := 'CF57BCC502726D0C3E70D491A3E2055FFA8B75E313533D996C47573E3F320941363979156A239EEF9B943B9676973F3931397164ECB943CF989E6701B2A4829E6051805C131047812ED3D8B8B7156679E7E4F8284F59A70316DB6378DE74477A1651059F';
wwv_flow_api.g_varchar2_table(10) := 'F4BCE16C6EC943E23AAF8FBDF8DA16D3D333253D7FEE2E86D8A226800FECD9A3BE17A699C2324804985F7A5EFC1D5E6BAA633130748320306363C392CDB43F227EB0A840AE09E0A3C78E29A28141008AE8AA15DC2E35B034015C9C1A877DCFE747BD6CAE';
wwv_flow_api.g_varchar2_table(11) := 'FDE120F07B879E7B699B32F98DA3185C4B0E4D875913C02183B52640AC74D69316FAA2D53141E01878151318829CCB763C947652BD432F1EDA6E9E7EDAFBCF1636D735015C09632B3238544E41D080FE531E263F462677EC4FFBEEEBF9E70E6FFB3C7D72';
wwv_flow_api.g_varchar2_table(12) := '8B323952802B016F95739018C607F082C2E8B3C308C2829CDB1F38412F4126935B11E40460200A374C744BF5711AE46C6EBFEF7ADFBCFEFCA1BB5B11E40460C05A647029C42193C7D527EF4B3BCE91F116043901B8C8E072740B67948F065E994CFB7D41';
wwv_flow_api.g_varchar2_table(13) := '29C858E46985E83A019808AA0F9E15605EB42083C904D9739C6F8C3FFFF26E73143E9920630E7DD3924D70235280CBBC58130C6E615D98B3F745907399F6BDBEE37E73FC85D7EE51909F6E6E902305B8A955795EB4E7ED7D11E46CB6FD1E04DC475A01E4';
wwv_flow_api.g_varchar2_table(14) := '48019E5786AD9FC1828C7932CCF53D7E0B809C00BC70A5B353282E6B6672CAE4898387F7D25C1F85B9EEC183030BAFB27E259AAA33F51BE6DC35CF320F9EBB00022F786C273F9E9FCAC05C7B9EF78D91E75EBDFF6980FC9563BB0D9F0E99AF82B8EE47DA';
wwv_flow_api.g_varchar2_table(15) := '9139C394B84654453B379907CF5913CA20F60E5CAC5D4F6159F36EC70D7A270EBE7ABF32B989408E14E079C3943945D682371564B120673BEEF6BCA077E48597F791C91C4D33303952805B95C156B516DE7B2D5101B263DC2323070FEDC756239E076A3C';
wwv_flow_api.g_varchar2_table(16) := 'C89102DCDA0C5E78EF59A20CE47198EB6CFB0EC7737A479E6B0E902305D832A1F5BEAB08B28A832CAA451993DBB73978FCA719404E000654D5045945840B3F66303993DBEE384EEFE8F3AF3DD848739D000C802C832B215BD8F90C268F8FC15CE7B6E169';
wwv_flow_api.g_varchar2_table(17) := 'A623A3CFBFFA70A3404E00068EF36C362C0C69E60ECD3541CEE4B6A0FEDED1838D013901187844C1E0195A500A7236B7D97800F9CB2F3F123793138049B8B9B70B676077CB178A20E769AE37E331ECDEB1E70F3F1A27C89102BCF099E42D8B2A868C75EA';
wwv_flow_api.g_varchar2_table(18) := 'BD828C152F35D7D94DE2F8AF8F7DF995C7E202B9B63F5DA9107B31D0A8B8DE1AA7C5596DF4DD2D32597DF21D00FB1F260F1EFEA2E9F9C31FF38101A89613021E75E391021C75E716557D33412693FF007F0DF25F78F407CB9AF501395213BDA800A9C760';
wwv_flow_api.g_varchar2_table(19) := '2A4086F7EFC5DF42FD062E07F88BC6A01E6BD709C04520EBE4838BF5177E4C833C8929D406C4F087EB0972A400C724A24A91D57C6EA749314610045924055F3C994DE7D62BC82FBCF2B865720F981C44864B641551CA318AA86650A72B805A7267B7F0E0';
wwv_flow_api.g_varchar2_table(20) := '3B9574FA63AFAA8FD4EBF697BD1FFE0E8F2CC77F61F9F0F7F491B7C2B2F8CDC9592A9FB720E33D0987F32F1CFE4DC830303DC67F036F1B409E9A53A400B3F3AD9728524E85296FBE8EC22AAA3D5AAAF17BFABCF2B7BD3B7D3F2C5F9A8FD79883ED147FDB';
wwv_flow_api.g_varchar2_table(21) := '1F46DA3885CA6572EB7CF15ECFBF78E84966E49E72143E3952807508EC5D93A7324534F89342C7F1F907A48EEBFA068BC70DF8B8E393E313B95CC72A58EE57267B7A15644E9DA874B588F3B69C26516204D9019FFC8909373F3498F7C50CE3AF48C9AA58';
wwv_flow_api.g_varchar2_table(22) := '13FB11F6674C6438E5B86B46A626FFEAD297BE767CCDD70F9EE0C3F57C4D46B59DBA2D010E85A5EF079A9CCC986B03EEE8D454E0E14D05043D147A98AFDEC7627B81B441F53C58945DD0BE8D68F784ECF93028BC29A3AA6EDCB60087AC019E26E7A4DB8C';
wwv_flow_api.g_varchar2_table(23) := '7165D89BC41B1CF87291F06E5532ADBA108D71DA7165C29B9AC20B80A6AAAEA8A4E06D0B306510C248479701C07C1896207BE22BC864569C09FD01AE818B50CC84C084AFC9A8B61F910659D576A291E5083267260C66328E6B96B86D7899833110346FC5';
wwv_flow_api.g_varchar2_table(24) := 'FA8142D9EE689FEC57D96B324AAEDFEACFDB1EE0524191B100593ADDB60283E3E670696FA2F91D29C0AD2F0E1B5D2F2690230578867D89460963AF6531313952806347A28E0D4E839C86B9E68BFB5AD33E2500CFA1241664A7A57D7202F01C00F3D634C8';
wwv_flow_api.g_varchar2_table(25) := 'ADC9E448016E4D23360FC2652033BA6E2D731D29C08B25C89A0DF26926B7D6142A5280172B8343C0A741A6B9C646450B045E9102BC98193C03E4545A527C816993831C29C0A11016FB51990C70B9E2E53639C809C0556A23414E9780DCACE63A01B84A80';
wwv_flow_api.g_varchar2_table(26) := '59AC14E46635D709C035005C0932CD75B3313901B846802B4126939B09E404E008009E0DE46689AE13802302B812E46631D709C011025C0972AA09963513802306B80CE414E6C900B9913E3901B80E0057824C26370AE404E03A013C03E40645D709C075';
wwv_flow_api.g_varchar2_table(27) := '04B814E4A558D66CC4142A01B8CE008720F361DC46809C001C03C0A5207383224E262700C7047008323728C864323A8EC02B013846804390092E991C07C809C03103CCE6F822E9B8404E006E00C07CF2855B8D71809C00DC0080C3262B41AEC706450270';
wwv_flow_api.g_varchar2_table(28) := '28ED061D2BCDB5BEA525C2BE24004728CC6AAAA2B92E03D989F641BE04E06A5089B84C0832E7C761741DC99FF7A39FE11F9247DCE5A4BA854AA03CF04ACB44F5EF5D296B3A01B84C1CCD7082B7A381C999885E769798E866C0B4A20F8CA6272BAE557B1A';
wwv_flow_api.g_varchar2_table(29) := '3F836F394C84D1A2DD9A2BCDA86B9E3233F2A3727DF7DC2C8D2C242F8B73CEA35FB3F421ACEB666DB1689D52FC00A7D124DE2A670552312A024A41512078F54DF1C38B95C2611DA992EEB3AC8778748A316945629D6E217FD886E6C78DA99BBC63AC0D75';
wwv_flow_api.g_varchar2_table(30) := 'B30CCB322FFB33394B5EF6957D4BC118BAF8F05C3F85722C1CDA490FF7D8C718538984626A756058641C8252C030E0CA44E0D278A551065DE387BF29DC52C150E0633062D76FD8D2AC8B793AD2224BF0A9AC9675E611975E47DB2120CCDF8EF78E756666';
wwv_flow_api.g_varchar2_table(31) := 'E667FD57476D1B2CCBBCEC475776A6A2B5E13AD3E884C88D71F4B3A271D6C54B6D407909DA623D155958BC5E293E802958082BD8B94E244B10A8C91C7D98709F0327A3202C730D021E1C11BC154CA41B82A57042A0513458D529B203756962DD10E0D088';
wwv_flow_api.g_varchar2_table(32) := '98CB009D4C2A4D1EEAE8CA49B06DCDB462219091E131319F5DB716A52C3FBCE056BC367209DAC59BAB5419C15ED37FCDF68F0AC50F197E3D8F0F805DD329C17D6B2558B1548225ED0012A245593306E08747C50C5E1773EE8A55B42C5F68C7C1D63FC503';
wwv_flow_api.g_varchar2_table(33) := '305940D6E6D232F5FBBF2EC1C6B5307760A0B2B8629064EAD838DE1C09B0AE5C17E7E479313F3D21E60284BB7A094C211800E0838776CAD4538FD93AF8FAB0745ADC5F1E97D44B6FE21AEA74C914028F93C131F19E7840BCCFEFB7D7D04690C1037127CF';
wwv_flow_api.g_varchar2_table(34) := '49EA6FBE63CD3A99C87213603ACA7ABFFB98785B378A199FD4BCCEA9F3D2F6F7FF66CD743B948D4AD33F2CC1A615E2FFCE6EF177DC09A55B2E410EF7D836158EED534126A7500F94B67F50523F7A0FE33925B294CA733390D99168523C00B3AF1C0CFA1D';
wwv_flow_api.g_varchar2_table(35) := '2CEB127FD532089271220782EB65E3E409AEAB6904031ED82DE6D7F64AEAADF7C5F9C1075630608EB90AE166B312740174D605C1FA77AE53669B8B50866EB084205061C01802E0AF5E01300120859E498B077FED6E5C21E6FFCE8B2CEBB0DD1999809559';
wwv_flow_api.g_varchar2_table(36) := '2F3E943058B94C020023501E39DE2772051685669AF50E8E8AFFC45E997A7CBF041BD6A812708C8696A9743C1C222C96BF6C2958BE529C33E7C5FD8F0FD13FB0DC473DB3A6820C66BDB7B08BF101CC8122A92683A1CA605E80B60764A5266402AB0D4121';
wwv_flow_api.g_varchar2_table(37) := '93F03BC86624D8BE5926D7AD921414C3FDF6DB1AD09813FDE29CBB285EFB1698C13C640AA1B403F0F5CBC59CB82CB21C7579F8E401D846300B60997CA15D324B814F4BB0798D98F74E8BAC60DBE8C40818BB6105004B8B1985F9259860B1FBE1A969C60D';
wwv_flow_api.g_varchar2_table(38) := 'E5C53BF0884C3DF1882A988135321C13C6A16351661640629DB45468D380C91A04AA0BE1FDFAA7F8002E8C25E05A2B06683C98300EF4C6A8B867FBED5D46AE00D4EF863FEBEA14431F46761A08BD2307B63C0800C6C4FDC777207808EC127CDACE2D106C';
wwv_flow_api.g_varchar2_table(39) := 'CADA8276F8D9B5CB2D10A1791E06C0DBD76B7D7C3921DEE45A942A41F437AE16871130594D201827AC411D8C139002D4ED0C0D8B390FA561A00470FD27F7C9D46F7D4EFBA44AA08A68158266DF5C1A5437A3EE844AB7AC13D663A5B53674051AE9A3AD18';
wwv_flow_api.g_varchar2_table(40) := '52EC00EBB00ACA1BE0B581EEC05569FBEB7FB28CCAB5813929B0107E6DFF2EF1F6ED920002A2E693F9F46FDEA3FBC4F9C529F8B13E71FAFAD547AAA22038A35F0DD6C10C133032549903EC360360329220B2ED82F99734F3AF847986B9E41488BE338BF6';
wwv_flow_api.g_varchar2_table(41) := '510781253399C75CBE0280AF6A541DDCB709CC7DC8820BCB115A20E7F40549FDFBFF8AF3F35336F062B0C8F63913609D5BD6887FEF56F8612865170346F42586143BC033C644A6C104AA8FA619BB8EC8F6FC3571DE3E2EE69941997A124C4150A32083CD';
wwv_flow_api.g_varchar2_table(42) := 'FEEAE5E23FB84BDCB74E8A39F319F20FAB4F37790894D6617937CC33FCA9064B007A65074CF46A0B2AA7308868058AA01F7426E846D4BB69A5984F2EC2C4E37C25AD07FC654830FAD50B602FA3735818EFD1BDDA072A9CB647869F3A276D2FFFAB980FCE';
wwv_flow_api.g_varchar2_table(43) := '89AC42DB1DA8DF294CD708641E26FC67A7C5FDA00F3104C0EDCED9F1CE1046F417208178130954966832391DE134A81347061F9872C88A9CB8877F2CEECF3F4676489BF9A80C30EB64A4AC5B22A66F400C2C00EC2EF2D89A83E55D6060979D8E8C4F8139';
wwv_flow_api.g_varchar2_table(44) := 'AB35B0D336C128E733B07170C8B215E0059D50803BA1009C8E8D42D1E8AFBB11B8B12DE4A78B70CE007C4C85826DAB11AC6DB24DB12C00A782A5DE7C472D8ADC05EBC17130A6207BD967BA1D8E6B15EAE49CBB729E5C268CE84F289958937D9F7A499314';
wwv_flow_api.g_varchar2_table(45) := '24CDA37E10849079004641CFE0AD543FF95085A8C10BF3E2A3206E4424DE7F0373CB4BD6DC51A0600BE7A0C16ADCA39F0360FEB60DB806C614CA3A7D1701F2A03016308862039860FA6135EBC81FAC41E40C5F4E8BA2B1C210DA80A5D076B7204A676CC0';
wwv_flow_api.g_varchar2_table(46) := 'C08BEDE1E39CB920CEFF1C17D904CB41B7308C60EB321654F8E1A2CE67607E3FE6DA9770BC8697F673DE4C6562F91852A4261AE29F37CD9A8763D50F8556A8824063AE684E5FB60023F00A5380F9B47481E958CD72CE5ED2289A26D7D0EFC14F071BE057';
wwv_flow_api.g_varchar2_table(47) := '2944FA744E9DC822360C369A8F4E038CB5220F586521C382B5C84FE66125CA5F8FDF6DA88BCA4286AAFF85DFA41F4500A7BE99D31B068A880DD8BE8C00D4E5500A0460C1AE0DE2DFB3C5B297E69940B26D2A18834A2881F3C1A7623E865508176FC281D5';
wwv_flow_api.g_varchar2_table(48) := 'E11829C0213673F513466FAEDBE5F7201C4E3F8A8CE15DC849EB00085CF6337D50806B37C4DFB05AA741410600739E0D06CA6A44AF0CA268C22160737D449C4FFB05FFB58A9D3271B509D9821530EBEB318D3A3B04F6034444BA1A60012005F0065887B6';
wwv_flow_api.g_varchar2_table(49) := '82A5502A067034FD08D40C950875AAD9A5590643FDBB3620DA7F084A82730DDC909F20536118B8611E9E421CE0BE735257D76E3E172E1745B567683DBA0459CD9B60F8E6CD539681C2294D38D51AC8A276080CCB870626571359C2FB0418EBD2FE26F85F';
wwv_flow_api.g_varchar2_table(50) := '329F8B0FB8AED317984B73017EF8EA7580042029F8A54BECF46A0D8E08BAB40128852AD7193094CA126E2694F507D7D5F4173A8866749A55980FD3AD5011B47DCD17E6C731A61429C0184AB489539F6E04415C49A2800A49170C46C0AA0E9855F834877E';
wwv_flow_api.g_varchar2_table(51) := '38F48BC8475083B560E526AC30E510E0A028CDB7CD87B9F500FC2A9542A74B9C5E61C103A699D174B01451300AA8FFC552A9E983FFE5548779C3681F39EC7FC103F1E9D2244144235C9B860936135896445E3D7271830A82FB5A46C7313D96704CF53A46';
wwv_flow_api.g_varchar2_table(52) := '6AA26FA5936A5E67CBC831EBC70E9EC18F390F93F9880D6C54482C47F30AF6190630DC0DE2140420182C80081643B80AA64B983B105CDD81CD05CC6DD5C4D3D49F38AFCCE6CE9273A65FBC5FD969DB24D3D662EE7B17A273B64B2501839D4B88D22F0DC1';
wwv_flow_api.g_varchar2_table(53) := 'FFA21D6C1A982B500CFA7946C76C07269EE58AE67879BB38C74E49DB387C32FD2D94D0DFBD55BC07F65805D17153029153416B9EED2B768067EB84B2839BA66400171B2070DD4D8260BDFDBBEDA242B839013668E43C00DFB701D321FA4BFA61B0CD87A9';
wwv_flow_api.g_varchar2_table(54) := 'D5952F08DEBF7BB3F8589E24823493CE9521CDA74A8168D9F4213853A500C361A635EF4E2817C146292A85C1428A606D5A37397034170610A8E11CAB6DBAA60D65D345941D58EEFCA41F011D9649FB06ED94096D9A9F5E93E02F513F016652F6DA9F717D';
wwv_flow_api.g_varchar2_table(55) := '43AA4D90188C306AE68701CD1944AD5813F6FEE871F1776DB12B5000369C77BA3FC3B4045328151894802C23DB2C32180F04E983BDE1722747E8F4938D98AA30B00A83B3ABB010CA70B01166DD5F8FE912D94586728BEFAC9D1E291B3350A4131711555F';
wwv_flow_api.g_varchar2_table(56) := 'D532AC93AE821B18DE6F3F6C95F234CC3EA26DB90B81DDB655127C6E556141C55AA51889CBEE698A9DC185A1DAD669A97861125F5C004863256A05FCE7BEAD58ADBA07267407188A2E12789A3C30860B1FE6FDD376F100669260C91580710E66FA7E2C54';
wwv_flow_api.g_varchar2_table(57) := 'D057227173414D27AA553672B182FE50171F00164CBC83ED3B7FD30665305949B7A01D421ECB78280D01631FA948586173DFFF18CAB3D65A1AB21C79BDFB7689FCA923EEF7DF15731CACA7756130760147B6C7DF0D4AB1036CA565474BC133E29DFCB3DF';
wwv_flow_api.g_varchar2_table(58) := 'B397012283A26065B7063BBA76CCCD064C2F287CF7D8A7E2FEF37F5B50614AF5E1003292E6102697AC0BB02DA77E929B058C90215C830D0DE73404CF489868710A73154BA2D8E4E076A4328B0AC40FCD28DDC045AE9281F1F4BFEA7701122273F787EF0B';
wwv_flow_api.g_varchar2_table(59) := '57B3BC7BB763AA056B43A581124EFDEA1E28CB3A9483BBB80160A97C5847E7B6A3028CBE6843BA9D48AD8B07F1D801C6FF4065854841324A4660E4DF0BA69624EEA96AA40C70340A86B0DC0F3E91D4911F58A1E3E90C1560582687E9D2B94171B004E971';
wwv_flow_api.g_varchar2_table(60) := 'DF957553C03CD2FF623993F7351A66FB64B92A054C30C1D03D650045A183715C67D6F92F1FC3E1DA71B8BCD80EA5C1A33CA9A33F44BFB0EB75D71DEA8B0D2C0CFFF752AE9373CF57237AF68D0A436509F7A00B8AAA0B2F53EC48FD13553AB23467977193';
wwv_flow_api.g_varchar2_table(61) := 'F77570DCF50123757A42138C3B7609537320280293393502C00E98D4F6BDB7A5EDEBDFD100868FDE14C1A5E9E3922404CF273E74EA4321AAB9E51175707101ACD2C77F38DD81C035E1B77376005B8137ACD5607FD0175DA61C05BB39FF254034B1541426';
wwv_flow_api.g_varchar2_table(62) := '2A0D1E1FA2196E7BF9BB927AF7173A1D52AB83F28CE0756FB8301E02ABF36CD64DCB84BA9C01F613EBE79DE85B58AFADBD2EDF9132784EAB43C6404E8603E4D61DB5BAC24E29C8141297143915C2169CF3CB53585E84FF044B6519C0D5BDD41259504834';
wwv_flow_api.g_varchar2_table(63) := 'D700CEF9F49C385B365A60382F66448EFA9C8FFB6C530546E91F03D1B70E8DE93DBF13D137A374D4C59530F7E459F84F047A9C8655824036637BD19C1990D4DF7E579C87EF167FEF76046808AA10C5739A55643C058271AA3FBF86C78F4E613CEF1F1773';
wwv_flow_api.g_varchar2_table(64) := '0A960353AA1963291956543F2305B8A0E733FB46D6D0FFC124A7BEF5231B59560A8EA55801236A4C5F0C842FD8ACC763FE16582D4F3F364B5266E5C479EFB8B49D8432140057534C8519842FE58E4EC85E1E09362DC4F77F22E9773F42A5B8C6F669BEF9';
wwv_flow_api.g_varchar2_table(65) := '301E7DBFFA5FB4494B519A0AEDE95AF8F7F028D15B1F61FD1B9B14789A443AB1D9C1655424551A3C15622E43592F82B57C889055D1ECB34EB657E71429C073F6B520247316BE902CE4402B07C86BCC472113A495D072B290010A81AF147469839C4373F5';
wwv_flow_api.g_varchar2_table(66) := 'E824D841005917EBE7918FD312D0CAF6F86C17F69FE512767B989897657593DE82A4D767FBE218A800FC70B1859B22980B6B1BEC3F53D80F0675FCF0E9501E69056653705B2AD2EF48012E0C6BEE0E9249F36644060A8002526051E55CE0B2456455A5E8';
wwv_flow_api.g_varchar2_table(67) := '9E6548641CEF57265E2398D8752A4B6C3B0CACCA6E549C848A4A905907EB63591E99384EF63B1C2FC753E9623463FDBE669146F58D85E39AB3060A7BBE146A77A970E62BC3FB2CB7D0E89442E7A79A1402C7691451E479788DF5B1DAB06EF66D3E256599';
wwv_flow_api.g_varchar2_table(68) := '8853A400978EADA67E36401091F5F766BAD2A031C13145976E36B6E85A486A5AA80422053832062F741449FE9B4A2052806FDA4A72A3611248006E98E8E3693801381E3937AC9548014E82ACDA718C5A8635017CF4D8B1E9B80A0BC9D327B50FF476ADA1';
wwv_flow_api.g_varchar2_table(69) := '52866532AE422835017C60CF1E55386CEF719F407702ABE84352A44402218355A6B81ECAB824CB827ED6B4D0116A171E500BF0A01A131BE717B665F05DA98EBC9BA4B924606508E951A6CC18CA78AE4273DDAB8DC17240EBCE65DC9358A8F9B82D83CD01';
wwv_flow_api.g_varchar2_table(70) := '2CCEE987FF7F72F83B39DEB22C2843CA9232A5300F1464CCDFD5A49A380645435FAC651E7DB6E70B26302F6533393C908CAED45473354369F1320599E5C7C786600EFFB8FD50CFB738A252195733C29A6128EDC0E8B35F7D10CEF829586AFC2596F83599';
wwv_flow_api.g_varchar2_table(71) := '876A46D3A265486F24076CB9E67AEEBFA45F7BF15D5E28952DCF1B96D8918635BE481B8E4AA6FF0F7876019225278BB70000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72346480960797157)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/dwg.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001568494441547801ED9D598C1CC779C7ABBA676766B9BB5C8A94C443A4451D1445938A65391244253064090E04C33694404BDB72003F242FC95B8088';
wwv_flow_api.g_varchar2_table(7) := '920303DAC73CE5C10960380E82248E48451B18B6150776048AA425C8811D381222C2272552072971B924977BCDD995FFFFEBAEDE9E3DE7A89DE9D99D0267BBBBBAAEF97EF57DF555554F532907C118A51D14D3D122CCE8A8B71EBEC74221661646347A4D';
wwv_flow_api.g_varchar2_table(8) := 'A168AD0CF35D7E71E4019C7D5E19B305C740294FFE355A66DDE95103AB6834308B3126088CC9FB99FECBFDFD377F4B3F3A7ADE7C74C437662CB0DFA7D172D398BE25CD4BC29DF8EEC813A0FC0F5B86B2C3FCA21052FA83A92AE36D5665BDF587E8907FD6';
wwv_flow_api.g_varchar2_table(9) := 'FFA9BF3E674E8E66D4C3A3D5F502B9250CE685115F1F19AB8EFFF08F767A45FFA5ADC3B98313D78A6518EC26F4AACDFDC1B00B56023F3B3CB77978E750A91CFC04909F5C6F905B02311631098AEA76A3CCFE6B5325A8AEC065B9E9FE68A3617132B0D5AA';
wwv_flow_api.g_varchar2_table(10) := '5C0EA6F39BF3879536CFCD9DFEDA6DFA53A315756A14E6BAFB7D8B96008F8C1C94B157577D680386E2D01EF06F577CA4B95AFBE89CBA303567F283B9879429AD2BC82D011E1B3B2332CAF85007F82DC25590B7D9DCB6501D9C2DE6F6D07A402E54F383FD';
wwv_flow_api.g_varchar2_table(11) := '8709B970E2A93B4493D50B5DED5DB704D86A3025D44D74937D504C8DD6C6F33015800D2A4C1372FE70E07BC7274F3FB54FEB2355D5C5905B024CB0B54114BA362A8557C9561236B4389CE819F11B0472FF60FEFEACF19E2B9C7CE6CE6E86EC18700A69D6';
wwv_flow_api.g_varchar2_table(12) := 'D12428AEB85338903764024D9E9A8326E7EE872B76AC9B216F78C0D466D1E0DA8EE0D1672C4C17ABF981DCFD8132CF175E3EBA5F34796CA4ABC6E40D0F982A2B1A5C0B9857948D2ECC14ABFD43B94F049E7ABE78F2AB7773DEAFC6BAC7F1DAF08097D160';
wwv_flow_api.g_varchar2_table(13) := '8B3B840C4DC6987CAFD1C1F110321CAF2ED1E40D0D581C2CAA29C7E0E5430C3937900B219F3E7A20D4E4F49B6BC7805792D3F212ECD49DA437BD4A1B42C830D702D9E87F2B9EFCAB43F390B90C90CEE018706ABF678DF493DDB08116CF431ECCDD139AEB';
wwv_flow_api.g_varchar2_table(14) := 'BF8C201F81E3954EC88E0127455723D3545D24A136D8E2103256BC7203D94381F63026A71BB263C049D1A58A694D631A845A9317179EF2A215AF81BC409E7EF9E98FD15C8F8D1DF146F1E0C0C20C9DBC4E5563DA25886437E479C3E6152B5E30C81EA650';
wwv_flow_api.g_varchar2_table(15) := '152C6B1ECA78EAF8CCE9673E7E04909FFDE819CDA743DAF55D56ABC771435AD48DD55ABB06F7D9E255BCE8256BD5C885AEE16331A4921BCC1DF00273AC04C8A2C92982EC187052379694CB3A8B9C879C1FCADD5D05E499134FDD474D56CF027F0A34D931';
wwv_flow_api.g_varchar2_table(16) := 'E0EED3E0B8C735D1F470A7B116B2EF7BC7664E3D73BFD6A3411A203B06DC1D1A9C6419B7383E8991AF7A2268A5B079C830D7FBB1B99C1AC88E01AF2A93542458C8B26127CB7E0BC025DA304490A7E878E5EEF495792E0D9ABC21015B243C52019B71B2A4';
wwv_flow_api.g_varchar2_table(17) := '8C186E588EE0D691E33590DB47C8B33F3EFA4027CDF586074C464D6BB0500EFFCCB38E341953282C6BEED3817A7EF6D4570F770AF28607DC92062700D79ECE43CE0FE46FD32A38D629C81B1E30C1B8D0E05AC0BC4A42CEED25E4B2D564D6D9A629D48606';
wwv_flow_api.g_varchar2_table(18) := '2C0EB0A05871BB90B49A0CB5902BA67ABCFCEAD3BFAF47318542680764C780ADC89A94479BB3CD8F9B94F65A559E803C98BFB55C56C7E74E3CFDC976416EF9C767B5621197A5362A855732EE46ED8A21AF69D3E721F70FE67617664AFF0A73FD65FDF0E8';
wwv_flow_api.g_varchar2_table(19) := '2B1C1ECCB3DCBE08B5DAB5B836A406C75021CD3553DC45A4E621E707B27B2AAA8A5F504093E5699251705E9B0D0AC78093A25BF40D5313D13EA80BBF7202F2A6DC1EF4AE6373A79F7904B168D2DA40760C78E1174AE7F592DDB06DD423C8B3A5321EC9BD';
wwv_flow_api.g_varchar2_table(20) := '0536E4DB6B09D931E0B649C969CF9169D292D49D5693288C905506FBC9E5FCA6DC2E81FCF2D147D742931D036EAB9412026BEE34EE8E1C07A30B1EB84BD4F0A78E7C5112291BE7109601E44239DF9FDDA57CFD2F8553473F4DC874B85EC06FAF91A6E5E0';
wwv_flow_api.g_varchar2_table(21) := '18702CB2961BD6AE02A44BF281398A9BAFA340C5FCD3F0A78E7C5192B012F982524BDFDC4CA9424D0E94E66FA11EE32DEE29BB98273B062CE292A6A7F98FED86D25A68AFA73DBC97C353BEEF07F895217F69D89E0FEB665DBEF64B73E5121EAEBF0913A6';
wwv_flow_api.g_varchar2_table(22) := '7F2ABFF63581CCB9323B5D2BB2743C0F6EA529EDCB4B891132A156AB25FFFAD4954260F4349DD9A5E469D32FD5427BCF1E17A6592E9EE9EC3D7B54D7CD745FC6DF5E9C2CFFCD3BCF7FE5371FF9E23F9F1DC32F2894C213224D860D09785E56106D50CC95';
wwv_flow_api.g_varchar2_table(23) := 'CB051F4FC29A2A6C247E266CC7C8F9643C8B29D446C7572BDD4FDE4B9EC799D9D9D0BD8CE9C3ED2A1A71C0F332BB71FB6CF81B6CFBB28C44863A4F372C609133D41882D5F9ACEEA380A70B810A10E7391EB8EA6401C05A65F18866B152AD54836AA5DE7C';
wwv_flow_api.g_varchar2_table(24) := '2BA5DBB0802914BA38F49603284F16BA3380479E63C8BC17498E9D8161A96BE928B8B7D2B19EBC4C8332F0EE2EF8D36899ADCBBE2683F79B091DEAABCD34756DF21032075E3A3339E8F1601E2E17241CC05CCB801CDD13678703F4826B1BBFD2D1DE5B29';
wwv_flow_api.g_varchar2_table(25) := '2FD3002A5AC34AE643F23519F3B1F59F6D78C0495141C82A97D10A90C54CF3BAAD21AACF65B58E01BB6C5A5B451B57C66FD031C849D58D5BD4DA8963C06BD0C2D6BE5F53B93B0AB9A9162F9FC931E0EED7602B2A810CC7AB13E6DAA59A3806ECB26956D4';
wwv_flow_api.g_varchar2_table(26) := '9D3BB67D4C16FDA01FE72E3806ECAE616929A9AD9A2CFAE1126FF8261987B274DB38870D6BA928D1E40E99EB961A8ECC8E35787D99E8A470BB15B263C0EB53832DE88590B9ACE934B82E0F8D730C78FD6AB00569210F613104CBC64B6F4CD8C48D1ED740';
wwv_flow_api.g_varchar2_table(27) := '7C8E0137FA8DBA333D2173ED7AB01F7BC8AE21D72C54B62E9F1EE026652890B12DE014B29868B776BA07B849C0CC461459D7907B1ADC029135C82A90B941E1C25CA77F1EBC0612EC8222DD9A6BB79E56CF443BEA40EE34B937063B42E2BE18D16457E6DA';
wwv_flow_api.g_varchar2_table(28) := '51F37A1AEC4890B6180B79A8E931B967A2AD2C537B24E43E687273907B263AB560930D13C898420964FC0885D7F5859E06D727A714A42253D1642C6BFA0D407689B83706AF714788CD35D7AE57831C6979DDCA5E47DB7B80EB1052AB492C643EFEB322E4';
wwv_flow_api.g_varchar2_table(29) := '48757B1ADCAAC43B90BF6EC85800ED69700700B9A87221E4A5F7935DEAAFF3FD60176258DF652421F7614CAE812CAA5BFBCB8656A5D11B835B956013F909B58FBB5018936B2047CADB33D14D08354D59C891103985B290A9D96B117A1ABC1652ADB34C31';
wwv_flow_api.g_varchar2_table(30) := 'D75C0CA9F1AE7B63709DE2EB8E647C6925FE0775814CB38D1F813BDDF2EF697087FB8135D799C85C13768DE3D562FB7A805B14A0ABEC34D75C04E1DA351D2F576143FFC2DF95105D95236372B49F5CC12FD05D841E60175274588668325E31D0E7B941D3';
wwv_flow_api.g_varchar2_table(31) := '33D10EE1B82ACAE58CC94D3771F5CD1695D3E857B5538C46F2D93C8B2A4F4424CB4BA65F2E3E91B5C3A729054CC1C1B8E81C3E4981AE202D83B70E99729840F721DF2A5FCD708CC3FBC50CDF31C6FA96AA278AD759DCA7B1E3B5FD30BDFDA02C5B3762D3';
wwv_flow_api.g_varchar2_table(32) := '14569142279A4A0142981458F922CEF9BAA8D54612E4F18695F287C20657AE62917772997C51F9BA1F7906900747825A0408E9D851182AD7A2F242C7872530845D026D93BA51560A430A014770FD41A536ED8314D9C4D53C4A88BA0C08A50F9116E7FDB7';
wwv_flow_api.g_varchar2_table(33) := '631D700BA02D932F40A7A94E213D3A50F12C20236D661BD2539B990765106EE53A2E27F056963BD1964F289DDF8A7403302A6853800E589956A67845A9B977C3B4A2E9163F8A49414819606A0DCC7219021B7A4CF9773F09E10274A588784E0E97121E60';
wwv_flow_api.g_varchar2_table(34) := 'E0D574E6C2CF54F0DBAF230DFE63DFDD7FA2F4CEFB00B1B4B48809BE3C0338D794997C47994B3F566AF617807733D2A383E11D96AA3C8EBA77296FE7934ADF78109D661BFA1A4C35DBC1FB28C3B0A304E814D31754F5EDEF2975EDA75147A1D549474819';
wwv_flow_api.g_varchar2_table(35) := '600805C233C1ACF2FCBCD2033742C830BB0218422560CB185CE549368ED11EFE13B9DC665C9688177986951EBC29CC476D5C18381741B4BC43F8E67B94D9F17115BCF51F00FD03683EDECF5DB9A4D4E021E5DFF5C74A6FDB8FF22126760AC9375F9E669C';
wwv_flow_api.g_varchar2_table(36) := '0FE83968F525BCA17FE247008C7A5314D207180435CD23CCA52917C01B4D246040948F68322428A0091C02A7E02D796A17351779251F851D7582882A2298065A4640284FDF70BBF2EE7A0251D0EAF11795DE744879FBBEAC34E08765CD8590D9066A2D4D';
wwv_flow_api.g_varchar2_table(37) := '79729E5AC535E36DDB58674A420A011315DF2308707C2BA8054B2D9DFE409959984E45338983D5286AFDF573E80C30E7063008D97E98AF8CB1F2C2EB187367A061FDD0EE5D4A0FDF1A6A1F3B03E2F5E00EE5DDF288AA8EFFA3D237FD9EF2B6DD05B81867';
wwv_flow_api.g_varchar2_table(38) := '791F5A6ACAB3D0F0FF433DE743987E0EA3C9103A07347C0063B31776CA94708D9B914AC002D73651B41317D04273E90D159CFD5B4082E926644E7342D2E135BC688208351A51D46A82465C70FE3BCA4CBD06DF0960BDACD27BBEA0FCDBFE20820C90A847';
wwv_flow_api.g_varchar2_table(39) := '0FDD02D09FC6076938DED20A44E082732F2973EE9B4807CB22B5620CA6B395BB43E92DBF83F11CCE18C7F045DE38DBD1B9904AC0A10021149E240320180850D3B1110DB680696A1101988C5E1C108B2991F67702E80D807156A977C79481F3A4B7DE0566';
wwv_flow_api.g_varchar2_table(40) := '1CBB5159060E5E1E69A0E5C81016C37269CE277FAD4CE582D2FD0F495562A6E9499760553E3C8F72E18973DA65BDF0C58DE8484C2A01C790E293A46C18197D287C09F81AF1746A61AF889288F70B334AEDCDDE0A0E05650A5361BF6079CC86F2F8DE6855';
wwv_flow_api.g_varchar2_table(41) := 'C5981FE9A98CD330C7DEDECFA163C0F99AFE79A8A9DE26294B7970AAB8C822F3752924AA301D8754028EC5C49364F0FB00075EAE8F450D9A5E3A49021B9A5CC5D88B8DD465B7CBC50B463A3A4895CB2803E3671690244415E1604A5820997A1B653D0880';
wwv_flow_api.g_varchar2_table(42) := '1806380EF3FDC2371D507EEE2F5470F1BF3154BC8AB9EFAF51751EE56CC611E9E8ECA530A41270AD9C22ED023CBDE37795BFF56E08341226C767403785AB9803BFA0D4F5FFC52D8C9D8B02D26161C354DE91ACC64C2B6FC7134A6FDE8DF84AA4BC28B370';
wwv_flow_api.g_varchar2_table(43) := '0D0B1F30B9E357E04C7D1263EB5E808E3A05DFF78FF4FED01F2AB3EB21158CC3E1FAE01434FA0D74801BF0016CD1E274814E25E058443CB11FEA661EE35C3F3C561B641E8A71936326E6CDC614A1D81C3F13413A411E0B168F2AB3158B1F5889F2063F82';
wwv_flow_api.g_varchar2_table(44) := 'C58B0338071498630D13CC698E1907ACF287C8DCA782DF8C296FFF97001516C34E832AF0A8E1D9D319F387762AB31DF3E7F75E51E6BDEF203F3C741F63B098EBF81B241AD299D3540286BE0957512D5EC40182B3DA2B71D1B5C42D2554C4C124EBECA0D2';
wwv_flow_api.g_varchar2_table(45) := 'B73D861C288CA65D162E704EED2464C405177FAE82F75FC43D2CAC600830132FA9EA9B93187B1F0FA74C7D9139E77C9763341DBA81ED580C795C059BB6A343FC3DE2314C706D3B4590530938E629279630FCDC598C9D45AC215BA0A2C1A1895658A49031';
wwv_flow_api.g_varchar2_table(46) := '51C6E54409D46042A5964A3E5CC771983F57E6E00573FAF56D682FA73AB01006D3A30CBCE9EBAFABE0CD33F0B61F517AFB03B2202256C460CC25E80AD3C101DB7D18D3EFCB2A38F70D5405B31F76CF44233A779A4AC0B12EC6271010D79B3FF899AA9EFD';
wwv_flow_api.g_varchar2_table(47) := '3B38CC9C07731A4327CB06AC4865B6601A4A139B08844AC7AA04184C0FB82680A92D03ECCC381CA6FF8169FE2FC4239DC08553458F9C9D403620CAE80098438FFFA752C30FC2D43F0CD8F7860E1AA74F5C6583B3E66DBF0FE960F60BE7918F9E353DF1E4';
wwv_flow_api.g_varchar2_table(48) := '1748B4A98DA7A904BCF4F7A726631C262C6AA980B38021486A29163E643E1B17803C30C7666E121A0A400558002C5C980AAC40F122AEDF02736AE12E68389C336B5AB98BC4B19C1FD693DD8B7B007FF515155CFD91D2D37FAEFC3B3E8BA11A632E57BAF8';
wwv_flow_api.g_varchar2_table(49) := 'FC14D6C275FF6E15CCBE893660C12325A18B005362C497C15F9848BB102182A4D9853681C5E269122231D53113AF6125EB3856B21E9472C2BD6058824CB4C4C8FCD2712092FE5BD101DE83D6A313103EE6CEB2CBD50F0DE5C2C6F96FA860DB3DF0C43F86';
wwv_flow_api.g_varchar2_table(50) := 'B2A9A92C12F5A033D5ACC285773AFAB78B00931EA62A0ADAA5E0F0701CAC59AA042878BF48B53850BB733B942E7F06C0E0898BA642EBC41A40332530273A4A30A5BC3D5F41BAAC0ADEF901A641AFC30C631D9A756313C4607F580F3F86E11E7371760806';
wwv_flow_api.g_varchar2_table(51) := '6685C3663826A72CA41230C4BC1814057CF3BD98E27C1D37698EA3C0B112736135770540BE87A1EF17A136D9FB7224389AD2597C6076979BAFB2DCEA343AC30DD878B80F206FC77EF1798CD5EF2BCD0510042F7F23A658F760AA04278CE6992D653ED4AF';
wwv_flow_api.g_varchar2_table(52) := '66DF460274A01ADF80B93A17520938D44240213C6A153505FF3D991EE22ED09E505ABC259A837B7D39985F98D30B27900EE32C03F330BF2D837134A332768735306A718048B87A058DD483DBE5138EB330E10C1CAB39CD621AD6D1870EC3CD8C8B3F8159';
wwv_flow_api.g_varchar2_table(53) := '3F87F11AED930D8795EA9092DAF227858031CE72EECAE53F0A93D31BC2E4D6218F022C920DAF19EC51CEA155DC01E2C601D3F2286328F327134ACE457F0CCD3E97286915B8B04188B61D523EAE397F16D0F0EC8BD7313D3AA1CC45CCA1653709F7A5413D';
wwv_flow_api.g_varchar2_table(54) := 'C08B842B1110A8C6AE8CA9C29CCEC0A129C3E3A5294C9AE5644E010088B3972078C2BD059A3481BDE30B212082E21E32EFC986C47290198FC50BEC299B8BAFD26084DACB3D5F769038A003721709F599A90B480BE7EDCA29DCE58209D351D3D301170D81';
wwv_flow_api.g_varchar2_table(55) := '4B9AAA00C1E0B11B95D90E01FE5655CF7C13B2A23345AD584E6821180158820394DBA78277A14D174F46F9A0B9845BE21489CE19B46FD980B2D8B9264E2A73F55530DB0B670A636D1F3614B83FCCC0B96FF93AD642DE471BDF46D9E8803EBC717902335D';
wwv_flow_api.g_varchar2_table(56) := '70D9DC9401669320646A1A97FD66E0305143052EE2E323D3D940F0484301733F96C722B4770EF9652A159527F7007BD580F4DC21E2FC78E697B0046FA0451C32608E51BF3C87C572F970203B0C9FE19236A60F2EBF6A0A01B3591114AE24C55009D2428E';
wwv_flow_api.g_varchar2_table(57) := 'D22CBC67A73F7C748790E2F4C827F798AFCEC08D033EBA4BAC91A316DA10FCA5A366EB967293EDAAB3FC36254B29607EFB26A088D0287C98E1154DB1245CE10FEBC6382BC1C2B4C9798F40F96158783F8C4DCBDF1403EEB48808CE060BD35EF398BC9F8C';
wwv_flow_api.g_varchar2_table(58) := '4FD7793D8352BA5ADC6B4D4312E8016E485CDD97B807B8FB9835D4E21EE086C4D57D897B80BB8F59432D760C78296FB3A1F6F4123B96404B80C7C6CEC473059C806E7CE9B8991BA7B885124CCAB81929B4047864E4A0A86CA56A7448B7C7B81908711ED1';
wwv_flow_api.g_varchar2_table(59) := '1211A9A24C196F651CA769F0A4A5850EDBBB8C5F45AB3CBC854FDAC416E2C3C3C2FED860EB365E72BEC91001073F7CDF9D9571B3A26809F04854AB57516FA98CFED596A1ECC1896B453E5783D083DB3014FC6E1632F4AF4C167FE5E52053042BE386CB8A';
wwv_flow_api.g_varchar2_table(60) := '32B44401BD8DBFD5923E77E9BB234FE0358BDF1A1ECCF29995703DBED9566DC07CA1E6E22D1053A54940F9D36D8F8FFD3BC590947133626909F0C2065C7E71E401E0FE3C5A850794B9878721BEA551BE99AFD46579B81B2ADB9D9094D6D760F8BE7FE3E7';
wwv_flow_api.g_varchar2_table(61) := 'C67ECAD856E1B20C27810D715250AF905802AE64FAFFB1F36DC4065DFDFE0000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72346910935797160)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/eps.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001215494441547801ED9D596C1C451AC7AB7A1C7B9C3821E14E488040B21B703836282159969BE5568410B6B22C525E40681F7908710069CD03025EF6';
wwv_flow_api.g_varchar2_table(7) := '095E20126421175E212E0112020208582E0901E1100A04C4BD0939ECC4E774EDFF5F35DFB83D6EC773F4CCF478BAA47677D7DDDFAFBEAFAE9EB6521138A3948E209B9A6661BABBBDA9F01CF9422C1B0C85824C70526A4F47C70AE579AB9531B3E1EBE717';
wwv_flow_api.g_varchar2_table(8) := '16A77BD4D9F78D49A75A5BF7B4CE9FFF68EB7DF77D673A3A52AAA7C797E789537D4BAD4B59808370F7AE5973933166E3ECE6E6A35899B2322EF5698A4DE7FBCA6F6B538373E6BC9C4AA7FFD1DADDBD1B9ADCA4BABB33530572591CD8E2754F4FE67FB7DC';
wwv_flow_api.g_varchar2_table(9) := '32D71B1E7EE5E89696F6BD8383C390B357ACACAB1E5FC3F08C8CF8A959B3FA67CC9D3B733893F92F2AFDB7D6071E985290CB02D193A5E20F0D9D06EDFDE3FEA121FA30CFF81FC66858A0265678D8F7FBA6B7B6AE449FB2B9FF9E7B16EAEEEE1168718A16';
wwv_flow_api.g_varchar2_table(10) := '8AE1F5ECCA02DCD1DE6EFB5E0D61A1CF655F4CC7535D1CAC241E2085C6A90FF5F7ABE92D2D7F1E1919995290CB02DCB373A765DAA435084356829898EBCB59391C1A18C8B4B5B4AC02E42D07BABA16594D7EEAA9BA1E5D97055834982CEBC99C59B3C34A';
wwv_flow_api.g_varchar2_table(11) := '671B246C8FF1706D7071687030D3964EAF4C29B5E5C0BA758B75676766471D9BEBB2005346F5E8ACD909549C263A7B4B79D05C6766A4D3CB53A9D4E60168F2A5EC93EB54931B12708EAD71BA4C0DA61FC6123C7B1C4F58C82D2DCB47A0C9844C4DAE47C8';
wwv_flow_api.g_varchar2_table(12) := '8D0D386BA2031A2CEC1D6498EB19846CCCF6831B362CB1903B3AEAAA4F6E6CC0791A2C74B36767AE09399D5EE6F9FE560B19F3FE7AD2E4C6069C2519A2C1C23A08F95CDC38C834D775A2C90960A0943E58A8E69D472137379F8BD1F5D6DE0D1BCEE40A9E';
wwv_flow_api.g_varchar2_table(13) := '853C3A40CB4B168FDB0470611C7290A703320663DB7BEFBA6BA985DCD9E91DC10214967B05633524E0DC3CB838C1E62063E0B554A34FAE07C80D095826BDC5F1B5B11D64AC78D50BE486049CD3E0D29656DD142A00B96FFDFA73ACB9BEF75EAC6E76C74A';
wwv_flow_api.g_varchar2_table(14) := 'A6B1AA4C091A5552929C0667A74925F4A19C0B7B58D61CA126638973DBA1AEAE3F81AEFF4FACCFF3ED90922A568144B1A948059EADE02C27194587E6833458BC362942C606C5126C356EB19031BAE6264C5C20278043F115E8190679DDBA659D9C42C1C5';
wwv_flow_api.g_varchar2_table(15) := '017202B8409661D16C5F9E0F3995DA0A4D5E4E731D07C80D09B8CC41568E35FBF27190D3E93F64CD752C203724E00806596320DB1BD1E48101F6C98B007E335E1AA839E486043C4AC7A1069B9C52E7C28ABCC8D7648CAE17635973F3E1BBEF5E21E6BA16';
wwv_flow_api.g_varchar2_table(16) := '53A8C6065CFA34691CFE9C55104D7653A8C5FEC8C836EC42ADB25328A4AAF6C0ABB101673145A1C163880721A7D30BB158BDE5701632E3551372029802AFC48E5010724BCBA9F815454D2027800138720DA69AD28D87BCB57FFDFABF489F5C0D4D4E003B';
wwv_flow_api.g_varchar2_table(17) := '1495FB3B16F22919ADB7F6AE5F7F51B520DB37FB2BF774F1CC9923DEDCA0A81A551C0B79FEE1C1C127FB376CF83B20BFC5EE01F5F10478D4D569480DAE2A5C2116808C5F502CC818B3D96A32A768DDDDA652E6BA2101E726BDA56D170AB2E2CF01C8339A';
wwv_flow_api.g_varchar2_table(18) := '9B17E0764B6F57D76568701583DC9080731A9C9D07174FAA8C14848CDF431D1A1A1AC662C849B879A2BF82901B12703E9E8A4C93F20B197B4FC84DD86A24E479D87A7AB2EFCE3B2F8767E49A9C0086A4A15439ABCD8B4A1DCC5AF266B1B86BC20FDE0879';
wwv_flow_api.g_varchar2_table(19) := '2EBE8CF06F40FE2B2173C0F514BF3610814B005388D9850E08DFDA4FAA57250E662BF9B2583B4FD67A5AF6CD907980FC645F57D7D50CE29E721403AF86044C2D0A38A33DCFC7A1F063331FBF32E48F0CF96BC3DC21F77296B089EE83FE722D67C99FF7E2';
wwv_flow_api.g_varchar2_table(20) := '8773AA7F787808BFA0381EF5787CA0BBDB42A626B3D105EA5AF46543CE83293142F600D51F1E4EF5EEDB37803DDCBEB22459B4E8C72738684CDFB4A6A613068786FEF5FDDAB55F9FBC69D3AE1EFC82021F86B16F888C4F31B94F430216B14085941A1C6C';
wwv_flow_api.g_varchar2_table(21) := 'C90C0CA47A331983B9A9868659F81287676910E217BC976B394B1C39E7FBE7DF07E3A1AB9886FB0CB4F80C34BEF9B8DE657F83DD231FCB90D8859F1B16B0081AE651A7D10FE2A4FA3219C5F76C6AD56FB1C135C3AA0C663223191C85639C3866C302A648';
wwv_flow_api.g_varchar2_table(22) := '0432A09A660877462A3506725E5F3DB114230A417DF061279562A3C3D4CDE62A9FC928B5885A35D652EB1B793A4286E33C49B740B06DA9948650F815370655F5601D3891CAD6C9562CF8990CEB51E49F86071C941775069015205B33ED742818A33AD751';
wwv_flow_api.g_varchar2_table(23) := '969B00CE631617C879D52AF936011C22BA9A42860589D22580279066CD20E7F5C11354AF60EF04F01144552BC82C372A97009E4492B5823C49B50A0E4E001720AA7A869C002E0030A3540D7232C82A904805A2E543E6B266E42EBB821555BE8906172949';
wwv_flow_api.g_varchar2_table(24) := '813C138B215CE7E57DA42ED1E048C559526684CAB56BAE78F1B58BC8219754ABF044890687CB6552DF8A414E4CF4A4B2AF5A848A418EF009120D2E539891434EFAE03289542079A49013135D014211641919E4448323A051A12C22831C61FD923E384261';
wwv_flow_api.g_varchar2_table(25) := '322B81CC79721CA65009E088010B64BCC5A7E20039015C01C071829C00AE10E07190A1D134DF85B828DFE948001722F132E210AA35D778DF19FF21AE20C885368442AA95002E444A65C611C86D05424E34B84C81D722793190130DAE05A108CACC871CBA';
wwv_flow_api.g_varchar2_table(26) := '9F9CAC644520E91A661184CCBE791C64F82526BA8680A2289A5009977DF238C8D0E0C4444721E51AE6410DCDD7E41C54808FD225A3E828A559645E02796681A3EB22B3B7D113C0A5482DC23434D79C1F1332CD357F361AA50E27802384554A5662AE0999';
wwv_flow_api.g_varchar2_table(27) := 'EF78F13C6EE0554AC6D93409E032841765529A6BBEA5C90D0A6A7254AEA17FE11F9510A3CA47FA648EAE477044E112C0514831C23CAC264383A745B4E0114D3389F00193ACA27DCF3ADE1A5C4C2B967E2B2C8D8485B59EB0F88CC734138585E52369260A';
wwv_flow_api.g_varchar2_table(28) := 'AB917F3C0153B0186CA869F86CD4648296F0E16107A4A565344D300C9F48721F12CC9334CB6882180426D330AF117CC5283F2C2F69EE9669F87D1CA6E399F73171F104CC01467FBF523FFD34B9C00886023DF65827D21F7E70F7CC43847DDC710E964014';
wwv_flow_api.g_varchar2_table(29) := 'E133CEC1834AEDDBC7CFDE395F823DFA680C67673A7F864B1862B08F1C838F65B3F13437BB746C2C52AE9453C373FC0053601432819D7186832510F305457F01C9C6408D3BF34C276049436113FAC0C0584D655E43434A9D78A252679FED349871098AC0';
wwv_flow_api.g_varchar2_table(30) := '99DF69A72975D4512E3FC647DDF001ABB175923A30AF9F7F0E2F87696BE4E20798A61982D2975FAEBC6BAE71D0089C20294C716C0804428D41B8BF7DBB32BB77ABD4CD373B4D2250E68574FE6BAF29F3C4134ACD99E3E0D09F9A397BB6F2D6AE557AD122';
wwv_flow_api.g_varchar2_table(31) := '07860D0466D67FE619E5BFF5964ADD7EBBD24B973A0D0D961DAC03B5379D566AEF5E9579FC71A53EFA48A9934EE227125D5912B746E7F80126380A67C60CA5A9C5D428F66DF98029300226146A0FE099871E52A6B353790446C1331C7DB277FEF92A0360';
wwv_flow_api.g_varchar2_table(32) := 'EAC71F1D648601B0BEFE7AE5517BD96FB3110194F9F453653EFE58E9B636ABBD9AE69D6141CD0DC2625EADAD0846E3435D0DEAC22FD7C6C5C5A726418950C328546A61F020300A3278301DEFA9C9DF7FAF7C7CB8D3ECDAE5E0B21FEFEB531A66D8BBF042';
wwv_flow_api.g_varchar2_table(33) := 'A50E1D725A053F9A5FEF820B6C0331D466E461D000FCA79F56E6B3CF5C17112C9BD76C78F97590F2598718BAF869B0088C9A4C4DE041E070E6DB6F95E9EDCDDDE74C34351C7D2635527DFEB9F2DF7F5FA5D8B7D274320C5AAECF3B4FA9D75FB7A6948D46';
wwv_flow_api.g_varchar2_table(34) := '5F7699D2279F6CB55FD34A307F68AE79FB6D67B265702575407DA89DE6EBAF5DE3A33FA166AD84DABF5F29D44D737046AD8E898B27E0A0702844C286D0FC575E51FEB3CF2A3D77EEA826495CC6E180089A6C5E784199F676A57158C080ACD12FEA8B2F56';
wwv_flow_api.g_varchar2_table(35) := 'FE830F2A7DE9A5CA5BB9D2693D359326168DC7473A6BAE690D82905807FAC122F8EC676921D07F8F89C37A10FAAC59AE4CD627060E35AA23476D617F4BE1D384CB59FA489EA14106DA6C0756070EB83E9CFED0526FD932A54F3D55E98B2E527ADE3C6772';
wwv_flow_api.g_varchar2_table(36) := 'A9BD30DDFE1B6F28F3C927CE34B38C3040042D65F22C07F3973AC44C9CF50138286C6A099DF8F14CEDCA9A716AAC5EB04099975E727D29E3320D0140F33507611C19331D0F84F95F7C61B55ECF9FEFA011E4444ED2F12C8ED71CEC49DDC43F06E7F89B68';
wwv_flow_api.g_varchar2_table(37) := '0A49CC344CA9D53C2E44D04FFCD9CF1E3EECC4492DE76816D0FD175F54FAF4D3953EE104D7D7028277C9256E84CC348CB7678FF25F7E5919A4D7CCF748DA4B90EC638F3FDE9DA9C174F497015910BC0BADE9DFBA02EC5D7BAD52181C594D11C098E270FE';
wwv_flow_api.g_varchar2_table(38) := 'EB3FFAA833B99CF2508B01C1BCFBAEF257AC50A9ABF13F2EB223737DCC314E4B0902F1CC071F2883C1975EB870142EF30E3AC6054C8DA95BEAD65B5D7A6AABC443C3F1918FBF71A39BDA31AD8405F3A9C175FC0153B81416046AE7A4722F42E44899DA43';
wwv_flow_api.g_varchar2_table(39) := '47ED9570A4E1F4C860D1C26045CC2E666441D9B8D070F3CD37765A64F365193C1827CC310C8DC45A102943E2C112680CD272F510FF189CD10CEBC851B03CA83D72881F1F8310828E26948328C6C9778CCBBEBB9851AF942D67A903CFF4CB2F3FBFCC1ADC';
wwv_flow_api.g_varchar2_table(40) := 'C75F8329B4ACF0383AB65A4281D29F07FB51AE35D3D10CD34FC27FFF5D7930A99AE657FACBACA9B62617832AEF861B54E6FEFB952668A69BC8B10E34E92C8B7949198C0F136D7EF945A9E9D3274A5D33FFF803A668284C8C82FDE79F0F9F0753F83C3892';
wwv_flow_api.g_varchar2_table(41) := 'A5F0D92F7FF79D5DCBD6CB97E7D233CCFCFAABED9FAD39A7C93DE71CE55D779D5D7FD6DC5CE0E02BDFB1D11022163F320F3F1C3E0F46F97690C6B831724768B231AAA55405C2D304C8BE367804B59690B9CE8C2911372B34173F38322620AC36F99C3E71';
wwv_flow_api.g_varchar2_table(42) := 'A992F1E0CF70EF8A2B943EE514A5386FA6FF4490E82FE506AFA5EF67238B99AB2FC014A0CC79696AE5A050A97959019BDF7E53DE8D372A4E91ECFC97FE00623712366D52E6CB2F47CD312C0335D75BBD5A294C9972263E0C14F3A13561B972963AB0E1F1';
wwv_flow_api.g_varchar2_table(43) := '8899AB2FC01420D7A2396AE646020F997F72218353246C18686AE4AA554E1BE9CF7E1A7DA48FE910FFF994BF63879DFFDA01181B06B45673E9122B5C764F9703B3302DA61FAD01372DA45CA9876C44C40C707DF4C13481D018EFCA2B9521386A0D9D40A0';
wwv_flow_api.g_varchar2_table(44) := '59459FEB73CF178325CE97ED562361302E1A8679EF3DA576EE547AF162A53EFCD06D09CA9C9AA61AF3660FF3651F712C40E6298E9A8B3C34165ABCDB6E73D6821A2CE5239EE6C20AF682CD73CFB93571A60D844B56D53EC71370D6A45A01514859C07655';
wwv_flow_api.g_varchar2_table(45) := '4A041B8CC37D5C6A2F767AF41D77286FC912679AA9F118D9DA8D84575F751ACE7933F2E45A3537F3B9CA6557B1D0103C6C4E183422FFB1C7EC72A72D9F654B1D009D7164549F3B931AB45E73558C3B4AECF763E2E269A209869A475349703C782D5029BC';
wwv_flow_api.g_varchar2_table(46) := 'A076C0DFD044A2DFF5AEBACA2D23322E569EECE8FB9D77DC1EB1CC79F97200B6067D6832F3E40A95CD1BFE766006536DA743C1B2593E8F60D9C13A04AF5DAC58FC8D9F0653503085EC6BEDDC92A692FDA8686E98D81887735EBE9D018D33D8F8B7031E6A';
wwv_flow_api.g_varchar2_table(47) := 'F6EEDDCABCF9A6DBA7651EEC73014A336CC70E653847E6DA321B08077038F459672985654E0EBA0CDFB362F99339D481A374CD461123173FC014265ED531E8CF32584A1CA3B5618213AD667F4BD0D8ECB770E94FA0006FFB542E42306FFA1332B51903AF';
wwv_flow_api.g_varchar2_table(48) := 'CC238FB86B31C5CC8303274C9B7CF6A77C498061933996C54D7FD908992C7E95C2E307980F4EF3CC3929B5A710D3C738D41C9EA9894CCF6B8221585A84B07C089365701D9980089F8D8069784818FD2773CC9F69B27DFC64D1AB151E4FC01416FB3B8229';
wwv_flow_api.g_varchar2_table(49) := 'C411806820DFB41098E2CF3E3DCC311EB7FF38280AA6617C1E7CF18E9A2E616179881FCB629A42B45DD254E11C4FC07C700AB590BE4FE28A96152B6081992F6C01C6F03A76B04B53C009DC29F028513FC2D4001CB554A6507E09E0290433EC5112C06152';
wwv_flow_api.g_varchar2_table(50) := '99427E09E0290433EC5112C0615299427E09E0290433EC51CA02DCB373676E89071798B826AE5C09E4049ACD2828E352F22E0B70477BBB853A628CC605B67412C6A54008A6B13F438507654A7F9171304E31D765AD6449EBC25B12781F06CE2D38907242';
wwv_flow_api.g_varchar2_table(51) := 'BA180AA3714545284B2B4391F16894E2AECA02DC912DCB6B6EFE063B345FCD6E6E6EDF3B3858C0D64B71956CA0D83E6498FA7D70F02B2B533CB8C8B85419E49BFCA2F24113A3CEDA96B677CD9A9BA0C31B5141FB3A43591917558BA911594CDEFEA1A103';
wwv_flow_api.g_varchar2_table(52) := '5AEB5B8FD9B6ED3F7CB2A08C4B79D2B239042BB0A7A36305B6DD5603FB6C98EC44938B21A2B50799E18D01FDFCB1DBB6E105B2F2E11653FC11E312F211232481454B202A99FE1F043029823CDF88DD0000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72347362123797162)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/exe.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D0000116F494441547801ED9DC96F1C551AC05F753B6D3B7136F684040824100888000ACB08909801890B9CE22830485CE6327F401207228D3920711AC189';
wwv_flow_api.g_varchar2_table(7) := '038334CC9045F120D0488811730031428346EC1020ECFB9A903D76DBEE7AF3FD5ED5D72EB7BBED5EAABBABDDF5A4F2ABAAB7D6F77BDFF7B6EAB23131386B8C1743366DCDC20E0F67E6C373940AB1613008453211CF98438383D79B4CE66E63ED32B9EB97';
wwv_flow_api.g_varchar2_table(8) := '1696A46BA9B3EF5BDB97EDEF3FD4BF6AD513FD0F3FFC951D1CCC9A91115F9F2749F5ADB72E0D018EC23DBC75EB666BED5F96E5724BA94C4319D7FB34B5A6F37DE30F0C98FCF2E5FFCAF6F5FDB17F78F84BD1E41E333C5C982F901BE2408BF746460ABFDC';
wwv_flow_api.g_varchar2_table(9) := '77DF8ACCC4C4BFCFE8EDDD70389F9F1039676A9575CBE37B62782627FDEC9225A38B56AC589C2F145EEB31E69EFE471E9957901B02311252F1C7C72F16EDBDECE8F83877C833F987B59E5820616ACC84EF9F1CE8EFBF51FA94DDA3BB76ADF1868727458B';
wwv_flow_api.g_varchar2_table(10) := 'B35828C23BD935047870C306D7F77A222CE973E98B71781D7150497980AC344EEFD4E8A859D8DBFB9BC9C9C97905B921C023070E38A63D9E278445568A18CC9DE59C1C4E8D8D1506FAFA6EF205F2D8AE5D97384DDEBFBFA347D70D01560D866527993367';
wwv_flow_api.g_varchar2_table(11) := '76A874D820C5F6D88C9C5B3901F242812C9ABCF7D8B66DEBBC2D5B0A2F77B0B96E083032EA44E7CC4EA4E298E8F0127960AE0B8BFAFA3665B3D9DD6343436B6FA34FEE504DEE4AC045B636D06534987B3296C0CF309E70907B7B374D1AB307C868722742';
wwv_flow_api.g_varchar2_table(12) := 'EE6EC0A1898E68B0B20F20E7F3854502B960CCBEE33B77AE779007073BAA4FEE6EC0251AAC74433F30D7025946D7D7657C7FAF832CF3FE4ED2E4EE061C922CA3C1CABA0859FAE48D45C898EB0ED1E414B0A0D43E58A996F8D3211BB337BF7DFBE5ACE039';
wwv_flow_api.g_varchar2_table(13) := 'C85303B49264C9B84C0157C7610A722EB7713C93D97FE28107AE7490B76CC9CC6201AACBBD89B1BA1270711E5C9B6003C82C86F4F65EE9499FDC0990BB12B04E7A6BE3EB6207A36B812CA3EB8E80DC95808B1A5CDFD2EA0CC82777ECB8DA99EB871E92D5';
wwv_flow_api.g_varchar2_table(14) := 'CDE144C9345195A943A3EA4A52D4E0709A54471FCA5C38732A9F9F4493658973DFA9A1A16B84AEFF27599FE7ED90BA2AD6844489A948139EADEA2CE7184597CD47D2C8E2B5CD0259FAE4F5B2D5B8C74196D1359B3049819C022E8BAFCA9BE5206FDB76ED';
wwv_flow_api.g_varchar2_table(15) := '16A650E2920039055C25CB72D15C5F5E0A399BDD2B9ABC09739D04C85D09B8C1415691357DF90CC87D7D9786E63A1190BB12700C83AC6990DD856AF2D8187DF25A01BFFB580234B92B014FD109500B9BA25217C36A3C29D564195DAFCB0AE4D3DBB75FAF';
wwv_flow_api.g_varchar2_table(16) := 'E6BA1D53A8EE065CFF346906FEA255504D0EA650EB7C9942C92ED44D6E0A25A95A3DF0EA6EC021A63834781AF128E4BEBE35B258BDE774089978AD849C0246E0CDD8118A42EEEDBD487E45D116C82960011CBB06A3A6B89990F78EEED871B3F6C9ADD0E4';
wwv_flow_api.g_varchar2_table(17) := '147080A2797FA743BEB0E0797B4FECD8716BAB20BB37FB9BF774C9CC99116F7150D48A2A4E87BCEA743EFFF4E8CE9DBF17C8FFA17B90FA641478DCD5E94A0D6E295C2516812CEF78AD2E58BBDB693253B4E161DB2C73DD95808B93DEFAB60B1559ED7E04';
wwv_flow_api.g_varchar2_table(18) := 'F2A25C6EB55CEE393134F45B69704D83DC95808B1A1CCE836B27D5400A20CBEFA14E8D8F4FC862C8F972F1F7D12642EE4AC0A5789A324D2A2D64FA35907B64AB11C82B65EBE9E993DBB7FF4E6EC6AEC9296091B42855D16A73D2AC83AC356F8A95AB1EF9';
wwv_flow_api.g_varchar2_table(19) := '2D149057C89711FE2690EF003203AEFD7C6D200697024688E1428708DFD94FD4AB1907D96ABE14EBE6C99EB7207C3364A5407EFAE4D0D09D04B1A71CC7C0AB2B01A3451167BD4CC697C3C88FCD7CF995213F32E4D786C543AFD5D7B04AD7D1FB7AAEBEE6';
wwv_flow_api.g_varchar2_table(20) := 'CFB5DE133F3B3A31312E2FD79F23F5F8EBD8F0B0838C26D3E82275ADF9B42BE7C1480CC81981EA4F4C644F1C3932267BB8271B9264CDA29F99E0B8B52717F4F49C9B1F1FFFF3D7F7DFFFC9054F3DF5D988FC82423E0CE3DE10999962EE3B5D0958C5222A';
wwv_flow_api.g_varchar2_table(21) := '644C3EDF5B181BCB9E2814ACCC4D3DD130075FE3E06B83D07BD16B3D575FE3A85F7ABFF43A1A4FBA8A05725D102DBE5C1ADF2A39FFCCFD067B443F96A1B1ABF7BB16B00A5ACCA3D727FDA078E664A16078CFA65DFD160D2E2756453E08335990A37A8C95';
wwv_flow_api.g_varchar2_table(22) := '63762D6044A29005AACD89701765B3D32097F4D595A5185388D4473EEC64B2343A99BAB95CF53319F516D1AEC65A6F7D634F076471CC93BC5E11EC4036EB8950F88A1B412D3DA80313A9B04EAE62D1CF64B81B35FEE97AC05179A13302D9086467A6031D';
wwv_flow_api.g_varchar2_table(23) := '8AC668CD799CE5A6804B9825057249B5EABE4C0197115D5B218B0589D3A5802B48B36D904BFAE00AD5ABFA760A781651B50B32E5C6E552C07348B25D90E7A856D5C129E02A44D5C99053C05500264ACB20A783AC2A8934215A296496356377E10A565CF9';
wwv_flow_api.g_varchar2_table(24) := 'A61A5CA324A39059E7E53A56976A70ACE2AC2BB328645EBB881D725DB52A9F28D5E0F27299F32E50D9A060593356C8A9899E53F62D8BD034C8313E41AAC10D0A3376C8691FDC209126248F15726AA29B4028862C63839C6A700C349A94456C9063AC5FDA';
wwv_flow_api.g_varchar2_table(25) := '07C7284CB252C88BE31E5DD759CF14709D829B2D1990E52D3E9304C829E0D94835109614C829E00620CE95741A64D168AEAB7171BED39102AE46E20DC4294296F79DE53FC45505B9DA86504DB552C0D548A9C1380A79A04AC8A9063728F07624AF0572AA';
wwv_flow_api.g_varchar2_table(26) := 'C1ED20144399A590CBEE27A72B593148BA8D59442133959A0159EEA526BA8D80E2281AA8C0A54F9E0159343835D17148B98D79A0A1A59A5C842AE0E374E9283A4E69D69897425E5CE5E8BAC6EC5DF414703D528B310DE69AF9319031D7FC6C344E1D4E01';
wwv_flow_api.g_varchar2_table(27) := 'C708AB9EACD45C0399D77FF0670CBCEAC9384C93026E40787126C55CF396261B1468725CAEAB7FE11F9710E3CA47FB6446D79372C4E152C0714831C63C9C268B062F8869C1239E6612E303A659C5FB9E75B235B8D6561CEDBB4AD346C3A2ADA8341E6195';
wwv_flow_api.g_varchar2_table(28) := 'E2C6912E9A470BCE930B18C1F748F516F0E92871E54004210110C22726E42B53F2CD3019A8B87480D2741AA6F0B84F3F97CB053ED784919EB8959CA6EBED9D2AB79A7495F26BF2FDE40246F8274E1873F468200205532A10152E8DE18C338CE9EB33E6F4';
wwv_flow_api.g_varchar2_table(29) := '6963BEFF3EF82891A63BF34CF9C28A4051E0E40FC89F7E0A7C1A0570172D3266D9B2001E1F35D2F45A2EE988F7EDB7C68C8F078D69523E69353010A4D37809F1930B18A19D7FBE31575D15884AC1A8C055E354A3103AB06810679D65CCFAF58166929A38';
wwv_flow_api.g_varchar2_table(30) := '3FFE281F2B3C39758FFC172F3666DDBA290D061E71880B5CAEB55CF2D1C684D65F7B6DD0602897C675EA94313FFC30BD5191A6CD2E998011EC2FBF98CCE6CDC6BBF9E6404408B29CC001811917ADF59F7DD6F80F3E68328F3D663277DE19985FC2E5F09F';
wwv_flow_api.g_varchar2_table(31) := '79C6D8175E30064D06C8B163AE0165EFB9C79873CF356674D498FE7E6345F3FD279F948F087E163414B4541B15E51F3E6CCCADB79AECBDF706D6828622C0EDEBAF1BFFF1C7034D261EE526C0250F30C294C322D8254B8C8736E2101861518DD2FB68141A';
wwv_flow_api.g_varchar2_table(32) := '24809CD91433EBD261926918A4250C93ACB0482330292773CE39815997F89E1CF6D24B8DFFF6DBC63BFBECA932D5840BD0CC1557186FF56A6380CB7DC9D7FFF557638F1C311EDDC46C7DB87B98D6FD491EE010A087E0803C3616484335186D554884105F';
wwv_flow_api.g_varchar2_table(33) := '0F951B82271D60F55018C4E15CFA4CFBD557C6BEF9A631975C1258877CDE995DEFE28B8DB770211F2A0D006AD9F4EDD218BC0B2F7479586954C4B3DF7C63EC7FFF6B3C4CBE36C2681DB55E6DF09307580503344C1DA039E7BEC0B29F7C622CE694FB3800';
wwv_flow_api.g_varchar2_table(34) := '029D7B984FD578C2350E69A3E69DFC24CCC324939FF4DBDE8A15411E62BEBD0B2E08FAFF9F7F0E066E00C6518668AF39EF3C57272F1CE163D6CDE79F1BB37CF9742B11A46AEBDFE40146F851C7358700C29C169E7BCE98575E09FA4D15BCC6C7C48A7975';
wwv_flow_api.g_varchar2_table(35) := '6659D311163DD7B8A4952EC01C3C68ECD75F078009E33E5ABA76ADB15F7C1100A671705F4CAF77D965C6231D6698BE5CA0DB0F3F3456FA740FF0580E6DA45A561B7DA979073940A1C5986ECCAC1E089B43C2DD37A0E77A2400000C0D967ED37EFC710006';
wwv_flow_api.g_varchar2_table(36) := '8D0422A656003B50E48B25C017B3EE61CE8987E5A0D1C960D0BEFBAEF118BC9167C25C6701068C0C8E3CE6A9CC57F5600ECA396617C157A341341601E4C9BCD97EF081B1870E051A0924CCF49A354E939D594653E97F2FBAC8784CDD2803E83436E9C7B1';
wwv_flow_api.g_varchar2_table(37) := '0266E9D200703565B7B011741660A0C8E2877DE79D602183C5063930B14634B1D85713AF1A074C1A8B68B0CB8334001270CEDC02997E17CB20A6D79967FAD970C06605BA33CF58141A01E013E6A4561DE054E8A235993BEE3076D326E32150042FD5CFC8';
wwv_flow_api.g_varchar2_table(38) := '39FDA57DF555B9256F4454A345C45133CD740933BD71633077C64C0B784F164198DF329A6740E5FA77A65700C54C639E753A455ED594DB62717706608482560AC8CC0D374C89887B085584EDBFF186B12FBE381556CD19E9C5794C9930D3320A77F35BB4';
wwv_flow_api.g_varchar2_table(39) := '56FA67FA5B4B7FCCA2888CAC5D1809C241971B847DFAA9314C9B009C40D759261A01225CFABF727E08AC929C039C91501A07E61633CD689AFE541B8DF8DEAA55C6C88286FDEE3BA7BD6EF10490523E73607BE04030A8A33E73941D29B5A5A79D0798D12C';
wwv_flow_api.g_varchar2_table(40) := '0B10F8622ADD881A93C935D067718273A60318AB57F4ED0C965811C3FC62A66564CC7489152F679ED9C8D006207364FBD65BC16A178D2481E699874D9E89AE2428E009C8C24B2F059B0A02A5A83568148B0D4C6358ECA8E454CBF0151471E5DC9351B07D';
wwv_flow_api.g_varchar2_table(41) := 'FF7D636FBFDDAD54590063A659D5BAFAEA60F14335551A8595B56A349E7067052A95D9E6FBC9035C4E20C010C096690903A9471F35DE8D37065A2B615604EED68D57AE0C3489F8A58E86C3C08C86C279340E5A2C661A0D76D0C42CEB400D33EDDD728B31';
wwv_flow_api.g_varchar2_table(42) := 'AC4B334AA61EA2EDFE7BEFB929565235571F3F7980A382D75A86BE13BA2C457A77DD152C4902469C33BD9CEB34A59C15A07130D5C194132F5A0EF1597B9670FBD147C65C734D708DE9C54C4B63429B5D1A1A08DB894CD5D85808EB105631719ED43661AE';
wwv_flow_api.g_varchar2_table(43) := '1C9CB08A4E2F113AA35CFA610E9606B54F9E25AD33C3A4D3FE3AEA878D839D2056A5DCA207E6581A82C7CE147BCB5CE324AE2FEBD70EB2F6C9414822FF264F83671193D3D4D27085AA3EE1AA9DDCE35CFCCC6DB719CB26BD82D2380CA864A3C0DFBF3FD8';
wwv_flow_api.g_varchar2_table(44) := 'CB95698FFDF2CBA0CF25BDC4F758DC203EE6593626DC420B1A1F2D2BB84ADCDFE40156C12B1CAE3930B198D6D99CA6254E241D603C5995E23F8C2AF062384B95F4CD986E59C460A1C4AD4E5D779DD35E3780A22EA1738339198CB9A5C9B9EAA389DAE827';
wwv_flow_api.g_varchar2_table(45) := 'CF44AB20319B089ED17278B019EFB4280A322A3C40900E2D65C5297A6883217E347DF45CD2323562FAE3B61E31C194493EF4C1246520C6489D7BD1B42E34797F92A7C14E8A326D41B89843DE734290000AFB5CB70F5B4EB86814A653DEABB20C8480409F';
wwv_flow_api.g_varchar2_table(46) := 'AD9A5B2A7FF21080D13ED7A59732AD8C92DD39797260CA8F1F0FE6BE6C2C84F52CCD3269D7C9048C40A5DFF35F7ED918DEB850C0DC97F55FF7B21CE7A50E9832CAE62D8D027BB995C046D311879D2200E2B00094FDFCF3C6BCF65A900765611518D0F112';
wwv_flow_api.g_varchar2_table(47) := '00BB57C4EB00974CC0080E8102939D227568316BC38495D360E211269A567C339234B3B9508B9DB6120F98740DBC5DC95B9A38F2E03E8D00B81DE4920B18C1D3EFB1CF1B75684E25B8C4232CD2674693963D5778AA915C2BF4B0DF75E9F43E56A2835C72';
wwv_flow_api.g_varchar2_table(48) := '012344B486A35607A04641D45B76AD756D72FCC48EA29BFCDC5D937D0A789EA34E01A780E7B904E6F9E3A51A9C029EE71298E78F976A700AB8B204460E1C282E13B13C5039661A52AD048A020D1344655C6D1ED1780D69F0E0860D0EEAA4B59E9CF099B6';
wwv_flow_api.g_varchar2_table(49) := '68DEE9791D1260BB12874CF155C69CD7E31A5AC9D2D625BF07924D54712CE7059A9C92AE8746B048EA64E8642A672AE3FAB26BF0ADCAC1B0D44C2EF7B96C981F5C96CB6D389CCFD7B1B6586FF5E75D3A5F649815191E743295C75319D7FBA4A526BFA67C';
wwv_flow_api.g_varchar2_table(50) := '30CB9281D3D6C35BB76E162D7E62692E276F9163AF53578B041022323B323E7E4C5E2EFCC399FBF6FD83F45119735DAB6B9843B402870607AF973DD8BB05BBBC836A534DAE8586E7C90B5FF6A86CAEFCF3AC9191FF91342ADB5AB28A3D2E15893DD32ECF';
wwv_flow_api.g_varchar2_table(51) := '302E99FE1F472AC582179D317D0000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72347683875797163)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/flv.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001506494441547801ED5D5B8C1BD7793E67865C7277B9D2C69613D9916C4B7112C7729BC48593E68AA6058A220FE94BE41A41F256E421401FFB102040';
wwv_flow_api.g_varchar2_table(7) := 'B6682D056991E722068A028E5D215BA0055AB40F7D682A142DEC5A4E85424D1347B6E458AA5D29B62EBB4B2E39977EDF7F66C821F7C6CB4F726697073B9C9933E7F29FFFFB6FE7CC658D5148716CAC4233536D225E59F1F6C3387A99383230648AB52666';
wwv_flow_api.g_varchar2_table(8) := 'C3F1F9AF7C02675FC2D1B289E3C8785E6F7FF939277D26AE1A6FE9A6997FF059FBC4B7AEC6F169DF98D5281D4F7E881D9E92D2F055C19E2E709FFE32F4F859B3545E9636DBA2C303C17F94AE14EBB609439B01485B30262AFF5A7CF14FBF61ED1FBE1EFF';
wwv_flow_api.g_varchar2_table(9) := 'F34A298E57C2FD027276B4033391126FED6A189FFFEAFDC646FF6496ABA7CCAD460B787A62B4896B8A6F3F3DF596EF3DEFA530BDCEFCEC71B65C9A9FEEDB6509612B32A57BEB66E9E49209821771E969FBF16F5E21C8E637F607C8A3D9D0D59493F14970';
wwv_flow_api.g_varchar2_table(10) := 'F8C3E6CE26194D70D9EED63DF376DB76AA97E6F7D6CDE6678FB3E5D2FC74CF6B721C53E49C056B056BE6D0C22741FBF3D0E413F60B2B81F9D18ABF1F7CF268009F3E45BD00CB22680334822C4B7F9DEEBA9C5C1EA7F45AF85D1CDFA9C766A9FA691306FB';
wwv_flow_api.g_varchar2_table(11) := '0AE4D1005EBDE40C6FE4318EA64716BC0BF343F1849A2279A4DEDC698400F953260C5F882F9C7D4434D9FC10D1B5687B61869525743480530D668B0EE26CDBF93D7676C7D915A112287B104E0B20EF0AC8BF0EB85F887FFCC71FB4F6A9D0FCE88F60AE8B';
wwv_flow_api.g_varchar2_table(12) := '09F26800F742581405EEA593EE05128A3FF283E69A9AFCA4894BCF773479B5909AAC0B702FE04539B7B4D3D4604BDD6610969AEB2771044DFEAED364439059B038490FE0420DBB07A054833BD91D906BD4E4E85CFCF29947C55C17CC27EB019CFAB50E93';
wwv_flow_api.g_varchar2_table(13) := '8A73242B715B24D481BC469F5C7902AB727FD501B938E65A0FE02DFC290EBE12206E4F2EF9E3CC75ADF2B12282AC07301954342D4EE9151F9C9E6C41BAA3C902B23D17BFF49D5362AE57F3AFC97A00EFC89F2D0CCB4F46DBEAB40F76A2CD6932CD75ADFA';
wwv_flow_api.g_varchar2_table(14) := '51538ECFC5179F79DC3E852954CE41D6037827D6E439BF4B28FB0499F3E45AF57113C127B7417E2AB753283D80C99F3D799433B4BBE8ED427B27423BD1F522400E529057A1C9F904590FE0BEF8B313DF269C3F1AAD9ECC94DD8AD7E326F4E0939FF9987D';
wwv_flow_api.g_varchar2_table(15) := '2A01190F0E4C7834BB76A7474C9736ECDAE7F42FF6D23AE8E20557BCA8CB6B8D002B5EA78C0F4DFE8FB31F17901FBB64F974C8F407E928D023845A319A664C8F27DBCF8377A7C72D6BFA58BB0ECCA1EAA300FC85F83FF307B21EC0BD5AB13B7BF271B54B';
wwv_flow_api.g_varchar2_table(16) := '20BB4EFAA58FA3F67117CA811C02E48BDF7D4234F9DB90F71C68B21EC043F1A75F3E8EBBDC48C473E5BAA3C961782EFEF1D927AD5D894C0E40D603981814458B533CBBE8ED3A1954A23A9ABC54FD205C156E50E403645D800765CBB4CAF762B9F566C330';
wwv_flow_api.g_varchar2_table(17) := '94394DA6B9AE551FC1132ECFE701E48309702F7CB254D99B39D479C75CD72A4E932F9EF9E434CDB51EC0BD5A31147FA654493458ADEF0CC8D0E41053A857CE7C6A5A20EB019CFA35353E4DB0219926A9F6E740E63CB9563981E0E4856981AC07B02A7F26';
wwv_flow_api.g_varchar2_table(18) := 'DCD8A00B1DFD91E7022F01B9FAB080FCD29F7C7AD29AAC07308753342D4EE9D5F3C1BDD077405EAC3C6C7C1F3728CE7C4E4026BB26304FD603386556EF10F37C4EF64B6A1FA4199A7B07F2FA2697351F3421CDF5773E6F57304F46C26B327A186C43F558';
wwv_flow_api.g_varchar2_table(19) := '1BDFA6BF7C657509E50440A6B95EAC1E03AC3FE880FC6D3C913B3E90477AF9AC0B2DF267AC3CEAEA4DE7A48BDE2EB475DAEF6E85BDF97283A256396ED63601F299AFE1D5CC7F01C27CFEDE4B4D7777B5D1CEF43478ECFC196DA05DB5B7A5B50BEDAEE28A';
wwv_flow_api.g_varchar2_table(20) := '272EBA5E6FB6105D1F97C0EBC2D9DF04C8A068652C9AAC07B02217C6DED4162C89F8B6A88F8314F65E32EB9B2DB358790056EFB9F822412601FA20EB023C311E29F35D163AB6A0AEDC49B639BE06631390AB0F981020BFF2CC6F8D03643D80C99F49F228';
wwv_flow_api.g_varchar2_table(21) := 'CBAF618F5381E434097F5D09A7CC92ECF452F63C739C564DF7D4C5EDEA8241D2922B27EF3A0164BC4F4D4D36DE73F1CB677F9B20D317C73FE4D706464F7A009374217F74A226DF02D84AE1CCBE60461D4BB6B6E066CF33C72CC794EE597EBBBAE8404AB6';
wwv_flow_api.g_varchar2_table(22) := 'CBA118AA955DE055BDDF7888AE2F9CFD1D690B8F0069CC93F50016AAF85380D425887CF5D58BB021C6F5F15D111FF1EC8437BFE49B8D66D3D416EEC3E33F7F195FFC9E03197365687B223EC3F1556F9A345CFFD3A90596716A62016A1CD5FDC6DADB0D28';
wwv_flow_api.g_varchar2_table(23) := 'EF9AFE92F480C3BB6BD64ABEFFBE66ABF5BD5BFFF0F55797BFF8FDCB66F534240F0FF40D990E26C06096530B3C3917D72B5E6BDDBFBB11C661185B0FEF09772978C25896DF2E3FE5FB6ED7B3D7B2C7695DEE991F99B88C7020B49EFF11EB95B020622E1B';
wwv_flow_api.g_varchar2_table(24) := '7907BBFDAD0C161D28E9014C0A8B94402F831DCC416D65CE2F539BEFE2B5E0080B883EAF6D3396BD86B8DBF5ECB5EC71B61B380B3337E799662B0CA216963615921EC0E4C8765C5120725C4D30D81190B19B2B5BB3C447AB364213621C7CE19FD746F380';
wwv_flow_api.g_varchar2_table(25) := '7D509EE9035D461030F7CD90B2836635FD4C461F4D6D57E4600659194E24112DEDB29D2B595B9BF72DC0B56034154DF2796D6C5BA60F60CD3EBBD2E9EC6732BAAEF477A2073049A334163C55A8C9F3BE7CA44F347892E31903FFF4001E037193E46DB6AF';
wwv_flow_api.g_varchar2_table(26) := 'A9829C2544E1580F600562F2D4C47E01590F60E7B1F284D1C8B454E6266CAEB778E0918780376AB4D23E32D16D96604C13D5E431F0500FE03657F6DF0135F9D0828F55C464EA54A021EA023C0609CC052F312E99271710643D80F7A10FEE122E825C824F';
wwv_flow_api.g_varchar2_table(27) := '4E408E0A22CC7A0073C00519741770039EA49A5C02E78A00B21EC064D418A2C001F93FFEE2194D2E02C8BA008F9FBDB9E9819ACCC02BEF20CF001E5664A0C965F8E4BC833C03785880937A6D90710F288F3E7906F08800B37A99E61A3728F0E08DBBC5A8';
wwv_flow_api.g_varchar2_table(28) := 'D0A656133380353849739D80ECE74C9367006B00CC363220E74993F5003E0853A4BD84210DBC60AEF3A2C97A0063700761A1632F8C793D35D7D4E469075E7A007364332D2617B698EB6982AC0BB01BDEEC374720CF001EA7386602AF723FE67A0C165017';
wwv_flow_api.g_varchar2_table(29) := '60FAE159EAE6C020208F817FBA008F4102BBB955D03300574AE6C97D69B2E230750156246CDF359580CC47722709B22EC0633031FB0A68F047A650B80B3529907501DE57688C6930D4E4E42ED42440D60578E683FB930ABCE03629907501EE6F78B35254';
wwv_flow_api.g_varchar2_table(30) := '840CC873789D51164390AFAD233380A7256E199097163C79A02F966FDFE912A407B0B6E8E98E339FAD81670495E67A69DE93274446FE6643CF48F5009E45D03DACEDEF545E5F4D03AF4544D7005B73ED5A0FE09906F787E84EA5A0C9BCC5C8E7AE0972D0';
wwv_flow_api.g_varchar2_table(31) := 'DAA9E060F97A6FF80FD6EFAC742F07A820B4829C42C15C572B437F77A5AB653D806726BA8BB1439F808F3EA2EAF94A79E826B215F54C74B6D5D9F1681CA0B21C2C13AD611E760B12B66B7F90F2BB951D106B36C56D3B92066C8AC5F54CF4109DEF5D85A3';
wwv_flow_api.g_varchar2_table(32) := '8491B173186FF2B5C14CA52C5B5952CE63F82E84A6FCD7829DEBB81A532576E01ADA876194EBAE9DB43C27A69D567082848FA7D98EF9747DB26DFACCDEB22C3FDD947380012E81096FE08365646216B46EC6115249DE02EA8428DF00BF591F201110EF1E';
wwv_flow_api.g_varchar2_table(33) := 'EC1D889D9A0404F5821BD86DE0B8048828202CFF1EECC99EA45DA984F271D3D8E07F33F9C8F30E639BCFE449E15CFCE41860323330B1B768E2CAC96D98DDCBBF04ACC80165BC0A0A50039D90784D8002700474A9CAF609A667A2EA4750CC09860801416C';
wwv_flow_api.g_varchar2_table(34) := 'BD856F296DE27A462850DED1F348D28E03DF06EF00F47792B2BD744DF75C0F60F2573391B1E14D132D3C66EAC77ECF44E543C686D0626A659756A59D82005C2BDFBA68E252CDB4963E84F29B00A464BCB061E6DFF881F1D75F8425BE1715F81139686974';
wwv_flow_api.g_varchar2_table(35) := 'DB44109EFAB1AF9A701EDFE60EEB009AF94D337FED6F4DE9F63FA2FCFB509682C2DD1D131CFE8C693CF0BBEE9C34B2ECF5BF37A577FF0606E038F26969F293F400A63067ADD9C863A4868159D0C4B072AF89E696A151D0406AA474C4CE12A972DF240498';
wwv_flow_api.g_varchar2_table(36) := '6553BE0D80A0F961F5882B4F0D85990EE78F03E07F4DEA266DC4EB269AFF0084E104846201E56BD27EECF9265C3C0180D107B51C4262220287AFE02D3E628285FB210C4D13FB15E36FDE84F6BEEB68493F9D97D285DC81932A0F1DB706A661C70ADA5A2C';
wwv_flow_api.g_varchar2_table(37) := 'E615FE149A68A18536C0062DB351FA194772031BFB155F8B030051BAFB13E3356F4B39DB5A976B51F5FD28E7C017DF4AE1B1109EF987B08796B7D65C3FC106EAB52020F7437B8FA02EB45A023094F70F41D0EEC1759870D2019A4AEB6F1ABFFE5FE0247C';
wwv_flow_api.g_varchar2_table(38) := '3C85611470517BD4EA6C229BF43438DBAADA3101046834CBB2F9D052BCE4557FDBF88DFF43344BFFC8C472F8A5466D5C81565D8359DE3061E95E045B10066820355A8221B102F4B77568ED11132EC0AC8A86A29C2C0C3BBF1D568EC02D1C355EE3A76819';
wwv_flow_api.g_varchar2_table(39) := '34C02FC7E587C49A487734E538F01A6F43B17F09F0214012496397A3947380339C4ABF2B287EF692A95CFFB3C4E7B10C4121C834A51B00BA66BCCD77000640253811BE225BB90780E1A3EA8D9F210F8900CF9D8206DF87E3B43ECA0A980134F530EA3C64';
wwv_flow_api.g_varchar2_table(40) := '3C6A27DB87C647734751E7308406C116844B341802E58237081B8589F57394E88C74D224C745B0191193A1B2C17CD23CC68C7A2B328DF1EB8C9A9147CDC73E2A2D0940A265CCA73F9D3F6142046FF2CE27CD6EEBAEF042FE85835FC5F563A84FB38EF621';
wwv_flow_api.g_varchar2_table(41) := '4021CC7CE461CE2C3EDF8359BF0D01B88C3298268990E8B052B3153D809D95D4A46DE7B6689A394FE5D4869B5DC4DE6DB14C77EA30D56F88AF144D03F3637F0E01D571B409499439720DE6F961D4038030CD1EFC7CA97E0DD7122D8460840B00D8077811';
wwv_flow_api.g_varchar2_table(42) := 'FC3080163F4E732ED622869BB8095FFF1ADA58421EADC024A51CDDF591F4009EE0D8249A0E5EC26C075ACA2DBC8ED9C99B387EDB2D88D843087C2E43C3EE087802080092C0891A18ADC39F1E9568D8F10800431B4B777E920805B51E1A2B7E18C1567417';
wwv_flow_api.g_varchar2_table(43) := '02F21E9C239062A25580D9F7377E81BEE17F65258C00E72FE9F9606AF058B538912068636BE903C61CFB73F8412E313281B900D006B7310FFE37F8C65BC636116C357E0950DFEB8AD0C462BA152332B6E1FFC0BF7E161B7CB47CE21DE6B67103D1F70563';
wwv_flow_api.g_varchar2_table(44) := '8F7C161FC4E2948C3E7719651E34DEC67904641F75E5690D00B00DD6214457D136023F9E6B8D5DAB9D64D47A00B3C1716AB1B48D15693038C0BCB575E8643204748BBC081134A3EBD2DD4B20E3758078070040AB0F7F0805A8910CB40070E93E63375F81';
wwv_flow_api.g_varchar2_table(45) := 'F93D01BFCCE54524CC69FDC65BF0A7FF8E08FC6BB8F68068709CF8E1D23B04FBBD28BF88BEF02F963CCFF89886F975046C1E84417CBA6B6AE45F651E62E48A4959FA76A28C3712A839E0AEECE55CA64CCC2387B8878FDCB82A916EC70FCF03E4A3285233';
wwv_flow_api.g_varchar2_table(46) := 'C1E243D8BBF21EB5B10161082F60CFE00C7E98532608061748E8E723FCD350FA714900D9C7F4C8B67E81328801C4FFBA4B79FBD5055859FA766216E7B65C27A619954507EEA1855C3674CC86C946E0E341C3BC66E287A979008891703C77D2996E0A2403';
wwv_flow_api.g_varchar2_table(47) := 'ACCD7761A2AFE2F894CCA3BD005328828F3A51155A3FF761679EB1202277B5D03F83382E5D4A943D5EDFB4131BFACAD735D1E3D460301BDC14C657DEFD6FF8DA97612A13132B3E18778242AC460537012E961CB93AD5BC0A4DBB01934BADA5F4E1813698';
wwv_flow_api.g_varchar2_table(48) := 'E970F1576072111D1318FC396D0460FEC3108AD764152C2A2F4178DC7C385CF855A92785E96F319DF2375E43738CE05D1B7D717B0A85F40076FC1BFF1000147D6BE9C61F605DE333497F21788F8D0CF709264D298C53740B656146A3C78023CEE9AB1174';
wwv_flow_api.g_varchar2_table(49) := '05D1E328E3864E0B4053CE1B0FA604809B88BE211466912B53A882E02D587A14F3654CCB2864ECBF498D7F15C79C43E7337A16E2F1A30730C63EA9147B55DC0CFA2202A6A3E271810EBAA684612FF358824DFF3A279AC6654B2E7430180ACB874D8C07CD';
wwv_flow_api.g_varchar2_table(50) := 'A53CB451FC6FFD759C5700E61CB4F61682B5374D134220D1310423A89D8479AFA08C4BFEC675594C313E23F4090E3C256080BD1EC003743A7A51301537E82D57AE24A500A72D036C6A346EC4FBF5571393EB56AC6244CE21E7C209305CD2F4367F8EB2B8';
wwv_flow_api.g_varchar2_table(51) := '2E8252429D2BB296CD5B949CEF86152C6726A2445F2FFE972B6912CC2120CB71A2281734A53E21DDF70E0342004DB7C13500F6162E269A46D32CDA4821C07FA1AA531B711DFEDCDD985886F98599DE84C9A659673D59EDA245404016AC89D018CBD5ABA4';
wwv_flow_api.g_varchar2_table(52) := '4D1CE535E51C608247266636F179FD309665002656ADB8E2C4885B12351B1BFF27346F1688FFA5368A4FA6D6E3BE30A63F0CBCC40A5073592701D3E3F2E4E6152997E6B986F3F9AB0B703F7C1F880F30BDF0A5314C6A8C1BFFB2A7F6091834CB7B251084';
wwv_flow_api.g_varchar2_table(53) := '756A9A692E6644FE7CD20EDAC22286877BBFFEC6CF5026BD59C001606D1A0197046710029A74D76F157B9AEFEBB224EA0239F501EF35A081AFEBFA602A9C5A2238F095B8B14E6D62A064306D21936D700BD718F4ECC5605CC74D08AF71C594D72E63EDF9';
wwv_flow_api.g_varchar2_table(54) := 'FD6D4DE6D31F25E479CD375006D3AAF6BD5CF68BFF62B8FE735CBF8235EB9ACCB1599EF3ECD21AEE0F4BDF1C6C3F42A6C690A11AD205782F7E0F4222A3612C03D21C2E5CFD0B30953E901DC0B4065860E013147B020C0024326E9AEAB5E704EC4E1D9AE8';
wwv_flow_api.g_varchar2_table(55) := '35B401167029B3DD16FBBD0742F52AFAFDBED44FFB6584EEC93C1B53A6B640E030C7491760ED8102541BE1319D4D9858F183894F965B84FD687042104CADD7846995C8373533D454B4C1B6DAE0A6E501387CBDB7F93AF68C92937E1935F3B6645BD892F2';
wwv_flow_api.g_varchar2_table(56) := 'DA3B4545D10538E59DDA800902358C1A934D348DDC0648BC670BA0BBB124271940F526F60B90ED72EF059C7702AE6D2EEA64A5F2A4D09A2EC08A92D7191B1BD5986B029881E8D3EAB73392BE8E06A271EF16E97CF492BA06EB915698969479A80BB0B2F4';
wwv_flow_api.g_varchar2_table(57) := '1506146D4215F9A80BB0B2F469F3AD30ED29F2510F6045A20A03440108D50358D1AC14806F8521510FE0C20CF96011AA0BF04C8B75A447918FA301BC7AA9E379F90676E74C67A0B3568CC9F278087E8C06F0E9534ED6BCC8C12BCF4D0D41C5AC4A8703A9';
wwv_flow_api.g_varchar2_table(58) := 'F692A74C298F3B25063A1A6D252B95AEC883F6E2FB6C3168C22F3439257320620E7C61F24E9EFBC20F79CA94F27848E68C0670BB53FB1A166E7F6A0E554E995B0D3CFA8F0BA9B9CE1EB37CEF79BB8D9C1DEC45E76ED777BBB6D3305D9D083CF4C143DE93';
wwv_flow_api.g_varchar2_table(59) := '044F914EEF54A1BFFC1486FE4AF794829C59DE1367767CFEE92F6381FE59B384F73D98466A595A38583FC2450CF90E5E9930F6F7EDE79FFF6B3220CBE3611832320C5902E2F35FF90420FF12C85A0665B8DF369A8B1F664085ACC3F7A3ACDCBEC2930CE1';
wwv_flow_api.g_varchar2_table(60) := 'DFD9CF9D7B91E3C8F276AAE322215325601F76AEC5D3FF07BBABC7E7ADBF6CA10000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72348097039797165)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/fw.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000011BB494441547801ED9D5B8C5D551980D7DA673A97DE6805C1D6969B16A8838A62894520410C313CF489A98DC1A8898991071E4C286363E2F8404242';
wwv_flow_api.g_varchar2_table(7) := 'F0DD4B0C187A81213C60424C80901040484808842A049002820A2DF43265AE672FFF6FADFD9FD973E64C7B2EFBCCD967CE5EC99EB5F7BAEDB5FF6FFDFFBAEDB3C7980C9C33C666504C478B706363D14A788E6A21B60C06A14821E219737464E41A1345BB';
wwv_flow_api.g_varchar2_table(8) := '8C731B2434AEBE599EAEA5CE71ECDC606968E8E8D0962D7F1CBAFBEE77DDC848C98C8FC7FA3C79AA6FB3756909701AEE477BF6DC1A39F7A70DFDFDE75099960A6EF6691ACD17C7265EBBD64C6FDCF8B79231BF18BAE79E23A2C97D666CACBC5220B7C481';
wwv_flow_api.g_varchar2_table(9) := '166FC7C7CB1FDF76DB263B3BFBC4B90303C3C7A6A76745CE51A3B25EF6F4560CCFDC5C5C5ABF7E72CDA64DEB66E3F8EFD2407FB8D220B704623CA112CFCC5C2A2DE5B2E33333845066FE0FE7AC58A03E2A2C7027560F0EEE943E65FFE4AF7F7D891D1B9B';
wwv_flow_api.g_varchar2_table(10) := '132D2E61A188EF66D712E091E161DFF7DA20AC2891065E571C54521EA0E4A4FEA72727DDEA81816BE7E6E65614E496008F1F3EEC99F659EBE4C4F9E156773677E4604F4F4D95D7A2C902F9F89D777EC96BF2C30F77F5E8BA25C0AAC130ED2673E6CD0E95';
wwv_flow_api.g_varchar2_table(11) := '66FCEF3DEB223977D22F031973DD572A1D3C71E79DDBECEEDD65D3C5905B02ECA5D3857F02D6F98A63A293ABA0C99393E53583833B4AA5D2FEA9D1D12F7733E49E045C41EB822E8BE2FA13194BE047A2D9F4C9E53503033BE68C39D0CD907B1B7062A253';
wwv_flow_api.g_varchar2_table(12) := '1AACEC03E4E969857C686AEFDECBBD268F8C74559FDCDB80AB3458E9267E30D701F2D573D61E3AF9AB5F5DC1BCBF9BFAE4DE069C90ACA1C1CA7A1EF2E0E055511C1F9C063203AF2ED1E402B0A0D43E58A956F90B204B9F7CF0D4DEBDDBBD2603797E8056';
wwv_flow_api.g_varchar2_table(13) := '952D1F9705E0FA385420AFEEEFBFCA46D143A7F6EDBBD243DEBD3BD7907B1270651E5C1F5C4D55812CA3EBAF5A31D7DD00B92701EBA457C935E007C8B2182290AFEC06C83D09B8A2C1C934A901C0240D53A814E4897DFBBE86B91E17733D262F0E34585E';
wwv_flow_api.g_varchar2_table(14) := '5B93E7AA326D7DD254E1150D4EA6494D0C94980B47A7A7A7E7D0647975E0D0E9D1D16FEC16C8BF91F579DE0E49DDAEA3A7B9A94827A570965174CDAA491E59BC76A504F276D96A3C0064AFC939825C00AE89AFCEC014E4B50303572864349912F2A0C905';
wwv_flow_api.g_varchar2_table(15) := 'E03A59D64AE6FBF22AC81276F0C4E8E80ED96AF4EFA4751A724F026E719055614D5F5E0D5976A12E17A162AE7301B927016730C85A00D95FA8264F4DCD89B9FEB280DF9F074DEE49C0F374026A615351EA4A5C83278B347960609BBCA9B9FFC4DEBDD7A8';
wwv_flow_api.g_varchar2_table(16) := 'B9EEC414AAB701373F4D5A84BF62155493C3146A5B5F141D945DA89D40FE8DE45AEE3EB9B7012798B2D0E005C45390E545BE4B65B1FAC0670964D22D27E40230026FC78E500AB22C865C2CBFA2E808E402B000CE5C835153DC62C8074FDE75D775DA272F';
wwv_flow_api.g_varchar2_table(17) := '87261780038AF6FD5D08F9A252141D3875D75D372C1764FF667FFB9E2E9F2533E2AD0C8A96A38A0B216FFD6C66E641817C9B407E86EE41EA1329F0ACABD393809715AE12AB822C6BD801B2B54066C1A42D907BD244A3C1DE35B75DA8B91BF7D390FBFBB7';
wwv_flow_api.g_varchar2_table(18) := 'CACBF6FB27F7EDBB51829DFC16CAB5A34FEE49C0150D4EE6C18D936A210790E5F750A7676666650AB5A51CC70F4E8E8E7E5702DB02B9270157E369CB34A9FA260BAF81DC27667A56A6509B65EBE9C189BD7B6F6A07E402B048DA9BC80400E6BB5D07456B';
wwv_flow_api.g_varchar2_table(19) := 'D9DC56AEFAE4B75040DE245F46F8CBC4E8E8F780CC80EB61BE3690812B0023C464A14384EFED27EAD58E8362B55C6EEBE7C9D6AE4A5E1AD82CF5D82F90BF4F147BCA59F4C93D09182D4A3927AFC1C67218F9B1592C031F7E64C8AF0D2B875EABAF714B5D';
wwv_flow_api.g_varchar2_table(20) := 'A7C3F55C7D2D9F6B0D13BF34393B3BB36668E87CA9C7FD5363631E329A4CA34BD5B5E1D39E9D26013912A8F1EC6CE9D4A79F4EC9EEFC444B926C58F48B339C746E62555FDF05D33333BF7BEFC73F7EF3C2071E787B5C5EAE970FC3F8374416E7387B484F';
wwv_flow_api.g_varchar2_table(21) := '0256B1880A19333D3D509E9A2A9D2A975D594CB56858D8C4D744E2033EADF5E96B3D573F95CD9F5687575F6B7AC2C544AF92BF65D1E2EDD2F8B6C8F9DBFE37D8E3FAB10C1235E67A16B00A5ACCA31D947E503C33512E1BDEB3E954BF4583EB17AB325D2E';
wwv_flow_api.g_varchar2_table(22) := 'CF95E5680C65EDD43D0B1871286481EAFA45B86B4AA50590D35A5B5B7CD9864A7DE4C34EA644A363750BA79FC968F64E9D6AACCDD637F37CDE340A6B11A71D10C1AE2D95AC0885AFB811B5AC07751033ED6FAA0F9AFE4C868635E2F73CE0B4B0D019816C';
wwv_flow_api.g_varchar2_table(23) := '04B237D34187D22996E73CCBFB1680AB98E5057255B59ABE2C00D7105D47218B05C9D21580979066C72057F5C14B54AFEEE002F01944D529C8DC372B57003E8B243B05F92CD5AA3BBA005C87A8BA197201B80EC0245936C8C520AB4E226D48560D9965CD';
wwv_flow_api.g_varchar2_table(24) := 'CC5DB2829555B985063728C93464D679B9CED4151A9CA9389B2A2C0D99D72E3287DC54AD6A672A34B8B65CCE1A0A54362858D6CC147261A2CF2AFB654BD036C8193E41A1C12D0A3373C8451FDC22913664CF147261A2DB4028832233835C68700634DA54';
wwv_flow_api.g_varchar2_table(25) := '44669033AC5FD10767284C8A52C8EBB21E5D3759CF027093823B533620CB5B7C260F900BC06722D5425C5E2017805B8078B6AC0B208B46735D8FCBF29D8E02703D126F214D05B2BCEF2CFF21AE2EC8F536847AAA5500AE474A2DA651C86BEB845C68708B';
wwv_flow_api.g_varchar2_table(26) := '02EF44F64620171ADC094219DCB31A72CDFDE462252B034977B0883464A6528B204B5861A23B08288B5B0315B8F4C98B208B0617263A0B2977B00C34B45A932B50057C96AE18456729CD06CB52C8EBEA1C5D3758BC4F5E006E466A19E6C15C333F0632E6';
wwv_flow_api.g_varchar2_table(27) := '9A9F8D66A9C305E00C613553949A6B20F3FA0FFEA28157330527790AC02D082FCBAC986BDED26483024DCECAF5F42FFCB3126256E5689FCCE87A4E8E2C5C01380B29665886D764D1E055192D7864D34C327CC0A2A86CDFB3EE6E0DD6565EDD676938AD25';
wwv_flow_api.g_varchar2_table(28) := '1D970EAFD59234EDD9D255E7D57CD5E139B8EE4EC00090C188E993EA235CBE4DA350B8D683F039F91A91C6F5F7877C7AAD00484FD8CC4C286BA9749A5E7DF2C9A797CCECAC86E4CEEF2EC04050B0C0F8E823633EFB2C0855E2E8BFF8DE9577F8EBD619B3';
wwv_flow_api.g_varchar2_table(29) := '660D9FB40BE0347D7A00A39056C937C8CE3D37349A5AE942A9E11EC9B96F58AB571BB361C3424BA1F139F0BB0730708180B6FCFBDFF2399C0163B66D3376F3E6206011B4870BF88909E34E9C30E6FDF78DF9F863638080B60F0F8773341B075CCA05389A';
wwv_flow_api.g_varchar2_table(30) := 'FEE187C64C4D2D4E974AEBEF411E1CF96860FFFD6FD0646D5C2136177FBB073066F3D34F3D087BCB2DC67EF39BC65E78A131E79C632CF0D06C042CF01CB0007DEA94895F7DD5B8871EF280A31FFC20E4211EA7DA4B6391B4E5071E30E6C5174DF4CB5F1A';
wwv_flow_api.g_varchar2_table(31) := '7BC9257CE630A409A917FE05B2E473478E98F8F7BF37E6D83163D6AE0D0D2547A0BB03309AFBBFFF1973D14526BAF55663BFFE7563D7AF0F1A441F88B0116AE2CB5938FFE217E51F2158537EE411AFF9564CB0FDFCE783155008683380A50159808985B0';
wwv_flow_api.g_varchar2_table(32) := '1B3786740A5835368D987C8383C61C3F1E1A17D75A663A5D87CFF30D18C1021733BB7DBB29FDF4A7C65E76591024C2C7A1D929B83E4C058DA6EA0088301A036198619C86A9AF90287B72D238B102BEB168BF1F72CDFFAD057E3E361767F9068CE915D369';
wwv_flow_api.g_varchar2_table(33) := 'BEF00553FAC94F8C15C8DEF40209F002C649FFE7E8933FF9240814E032E8B19FFB9CB15BB78674A41568F1F3CF1B2B8D25A22FA66C1C65BCF59671FFF887710CAE1830E1042ADF90C677274F867BD00008032C07F7FAE083D088284F1B482821177F93A7';
wwv_flow_api.g_varchar2_table(34) := 'CC455D165602AD42600238FAF9CF8DBDFCF279B80856342C7EEE39133FF144187431D841E8089A411566F6DBDF3696734CB06863FC873F98E8E69B8DB9E28A0580E3D75E33EEB7BF35E62B5F09FDA86AA696278D28BEEFBEA0F9944703A37E387C0EEE41';
wwv_flow_api.g_varchar2_table(35) := '7D73E6F20B58403919D5DAEBAE33F6AAAB82105573451BCB8F3FEE07379669900CB4FC1407E12264CCB2E475070F1A47DCD050E82F13D87CB637C11370A0A5175C103456E1A6411146991CD44101130EDCC49AA4B3E4E53CBF80012520A31D3BC2800AE1';
wwv_flow_api.g_varchar2_table(36) := '621EE5F023E33FFFD95831DD7EAE8BC0150C69D070E6C084938FBE17938B764BFC02B84282A98F3D1324CA64844C1A1A0BE5A9A39EE96B0DCF899F4FC00854064276D3A630AD11381E165A7DFAB4899F7DD63880217431D58C649D3406FA4CD129F93630';
wwv_flow_api.g_varchar2_table(37) := '7FC5910FC7685734D9098C4A5C88F17F7DEA6A485A062988937EDEC9FCDAD247D36888A79E5CAB79469B73E6F2075805479FCA881913AC0E8132983A7224089A34A25156A64ED179E7F9298EFF24BFC2111FCDC4D43BE9AF2BA655CB3B93AFB0802BD3AB';
wwv_flow_api.g_varchar2_table(38) := 'E88E3B7C03F18D8630AC815808F7D24BC6C85CDB7713D58DE44CE52F535CFE00F3E068221A49FF8976283084CEA89A552ACC30E732988AAEBFDE581626D0661A81C2219F68AF934154F99967C2C205F15A5E2264F42ED1F92444232446A0F9F9F34D37CD';
wwv_flow_api.g_varchar2_table(39) := 'C7619631D732702BCB0247FCD4537ED4DE50039A2FADAD67F904CC23AB960024ED102E8014227168931EA4278DA6235E819247CF094F5C4DB8954889A54CAD07657060FE09E39C7BE1E7D0E5133010D010D162AF1569C131C861344C9C0A956549B9D67E';
wwv_flow_api.g_varchar2_table(40) := 'B8028372D2A0D3E5A4CE41B32464054883A33CBDE69CFB120E6CAE73E8F20718018AB02C0323D677D32081250B182C7C987FFE33F4CFD20FC73265F2E1F4C9D2674737DCE0076895BCDA101A050034FA70D9B48831F1DC1F98EAD307BFFE7A18CD33626F';
wwv_flow_api.g_varchar2_table(41) := 'F63E8DD6AB81F4F9034CE511209A2AAB44EC0AF915A944735883B6575F6DE2279F34F6CA2B7D63708F3DE647B6AC48D96BAF35E65BDF9A37A92961F89DA0A520A8094EA5F7A784B392258B244E363BECF9E7076B411DA55BF0BB590C04D1E4A5CAAE2E73';
wwv_flow_api.g_varchar2_table(42) := '19AFF30B98C111539337DF3486552C34072D91C155B473A771BB7619279B0856B60CCDC517FBC194DDB2C518194D7B41D7309918D15A3DA537AE35D25738D0BFCB2A97C524D3F0A41EBEB19040E7D939844BF5A479E6D461A6C51C3BE6BCAC1123649C08';
wwv_flow_api.g_varchar2_table(43) := 'D40AC4D28F7E64A2DB6F0F73DCF7DE33E69D77FC68D9F78B3406718B7A451A8BCCA3173901E730F94B9959E0D355B049819F3ED0E49CC2E539F3A9C1D40C61CB14C81C3E6CE2A79F362599EBFA050B840C64D9E82FEDDE6D9C9864475F4DB880053E879F';
wwv_flow_api.g_varchar2_table(44) := 'DE2078E02403A1E8DE7BC346030D80F0243E626F594CB05FD7A6B1683EEAA12EC710B58AB5FCFC02A6B668870CA8DCA38F9AB2C02E311765040D4C0E31E356360E2CE980487FC981D9A4810091D138878447D2377B938E16ABE6493E7BE9A57EFFD7BDFC';
wwv_flow_api.g_varchar2_table(45) := 'B2712C5A2860F2930E3FEDBA0876BE01030DD32C831877FFFDA62C03AEE8C61BC3A8159040A45F44E01CC0E040435908C1C9C89A95AC050D803885A4E9F59A3C34085D60C1E73AED54FBD361393DCF3760840E44842CE7EEC00153967DDBE83BDF099AC8';
wwv_flow_api.g_varchar2_table(46) := '1B1ABA940928D28BF05933F623DFFFFCC7F7CBEE85173C7477F468B0009489233D8D285915735805B997E30503CAA5AF65B04717A0E9D37E08CDF5DF7C035661020408B2A56764D9317EE51563E4751C5EE1F1AFE0306746A381255098CEF88D783497E5';
wwv_flow_api.g_varchar2_table(47) := '4C5EEF116031EF66A966A6B128681A802C8FFA749489A6522EF36BCED164EED1452EFF80112600808CB099876296D9741080F20F9E7DBCBEEDE8FF6B27F3531A04531A1A02F94977E4C8BC494F43021E669DDD29FC77DF9D4F471C8D82BE9F72BACC7507';
wwv_flow_api.g_varchar2_table(48) := '60848A7011367081C0369D5CFBED3FC2135759CCD0F4340CE2B9D617F552E97D364D8B7612974E471CE6BFCB3457E5D13D80B5C6081C6173708E539F7360E01422711AAFF9428AA5FFD69B6EE9127213D37D80119D0253312A4CBDAE95261DD743E7D2A9';
wwv_flow_api.g_varchar2_table(49) := '156E254BA000BC92E9CAB315800BC02B5C022BFCF10A0D2E00AF7009ACF0C76B4983C70F1F4E26A232739199E70A97D5B23C5E45A0C9DDD2326EA6022D011E191EF650E79CB3AC155516179AA94991C74BC02FB5CA1932254065EC239BF8D3D24287B62E';
wwv_flow_api.g_varchar2_table(50) := 'F9AD8F6CE1880B0B10402FB4B90918C82D111CB2F4A72AE3E68A6BF18D8E91E4AE517FFFBFECECEC1B1BFAFB878F4D4F276B85CD56A9A7F3C522C3D227D3D36F205324A1326E562AD526BFA172A489A1B3BEA51DDBB3E756D1E13F4905E5E708BE4F6EA8';
wwv_flow_api.g_varchar2_table(51) := 'AC5E4F9C68AE393E337342364C7E76EEA1438F2093B48C9B91514B80AB2B707464E41AD9D2DB25D83788B12934B91122D6CAEF75DC7191DD5FCF3B74E8C56AD9365254E66969659917DAE3056625D3FF03FB2A8C7D598864BA0000000049454E44AE4260';
wwv_flow_api.g_varchar2_table(52) := '82';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72348484444797167)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/gif.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D0000149D494441547801ED9D7B7054D77DC77F7B57FBD00B84106F1C1E860102C4011B6CE2C4C6184F53A7C11EA790DA7593B67132D319DBD88D4D68A733';
wwv_flow_api.g_varchar2_table(7) := '554D67DA49A79DFED3E94CD3CCA4310FC7A4766A371E4FF09340FDC0260F2C8C8D0D9800060C42023D76A5DDBDFD7E7F77CF6A250BB1D29ED5DE2BE90EAB73F7DE73CE3DE7F7F9FD7EE777CEBD7B11B1B385EC5453BE5A1A1B1B1D5C3DF0FDE82BC1A23B';
wwv_flow_api.g_varchar2_table(8) := 'E44228A80489C8A66FDDB3D20985D7B992A9C3D78C0865E6D3CD75D13E371E8E44CF555557FDE06FFEF9DF3E7A72FDFAF0869D3B71DCEB8F4F5B3EA8661505381FEEE66FDFFB35D7757F188FC5C6B305A16130066AD5503BA01A09C64E242AA158FCF98C';
wwv_flow_api.g_varchar2_table(9) := '13FA8BC67FFCD763B0E40A7CD2A85AB3200DF43654F968A7B31A9FFEEBEFDC3B2D9D717755C52B17B72712DD38E9B0E26200E44BB5BF7AFA3B965FC6EC9B7C26E5F1EC7E08469CA988C63BABEBEA6A53E9F4EBAE13BA7BA4412ECA87EECC4AB13BEDCEC5';
wwv_flow_api.g_varchar2_table(10) := 'EE82CE6492471C48D081356753EE17F7F1EAEB5D477FC7FABB8EC96752E611B64D8D3F54C106A733E9B6EACAF80DA18CBB6DCB23F7CF8105A7F0097B799823B85B5180172F5E4C6380E4C321174331DD322C5777F0279B9AEF7E4A193678DE1D7B61C00F';
wwv_flow_api.g_varchar2_table(11) := '757426A43216FB82EB844714E4A200373535A98BCF84D22E7620A6E0693A2C9A9BCA219148A4E3F1D82A85FCE80357D3929F7C727DD6DA83D7B75CC786DA7463C1F473905300F1667B1E1297EE863E2691487A90C5D9B1E5D107E76FD8B0331D64C84559';
wwv_flow_api.g_varchar2_table(12) := '70BE620497AE6AA769BE5A6BA213902B632B10746D6BDCFCF0BC2043B606D8F374F9C803B40F0BD6D6223244EAC01779961C8DAD70DCCCF62043B606D8984080B0F63435173DE47AE1597212964CC899CC135B366D5CA096BC3E5863B235C023C282B386';
wwv_flow_api.g_varchar2_table(13) := '9C25DF033916BB16C79E68FCABFB1762A52B5063B235C039DDEFB18BE0EC7DDA824DDB739063B1D8E7C3E9F00E85CCC00B960CA5F67DB7AD01361209646AC6E0DE166CBAF229C85B363DB48896BC330090AD010EB48B36282F9F2AE424C6645A32FAFA93';
wwv_flow_api.g_varchar2_table(14) := 'C6471E5C42C81B08D9E532803F376B80FDD9BDC1B66A404EEA92130CBC62D1A56127B483907712F2860DBE856C0DF080A219AC9CCB96FF8A7E482D998B21B0E425A10040B606F88AA2291BB4C15CB82035CDCE9313E9CA5874092DF9B1BF7CE01A63C958';
wwv_flow_api.g_varchar2_table(15) := 'DEB426D3C1B4FC7279AD35A620D15CAE15E53E9E8BA20B5653CACD4924BB52B464A97008791921737DDE4F90AD012E5834E586D9DFF57351747F272F738C8BD7AE1BC6989CC2430E8B70436DFB639BFD07D91AE0405B708EE1207B9107B9321E5FE8A643';
wwv_flow_api.g_varchar2_table(16) := 'DB1B1F7D68392D9955FAC192AD010EB405E7000FA1177D203B2177FB63DFDDB80270F96C57D9215B039C9351A0770669C1A6AF7990E1AE17B861F10D646B8087281A23A2F2A6B920AB88662864D131194F86CCC37322DBFC60C9D6000FC1B915214DCB45';
wwv_flow_api.g_varchar2_table(17) := '871264F5D7043EB1D41378CD27E4C64D0FAC2CA7BBB60678D45BB0019EE7AE63B1E87C074F863CF6C843ABCA05D91AE09161C1967A91859CC43C19CB9A735D07815799205B033C322CD8622F7296AC9067E3D1D3B240B606D878A840A6B931D892051B21';
wwv_flow_api.g_varchar2_table(18) := 'E45932DCF56C096576FCFDF7367E7138DDB535C09645634414FC341F723C362BE36231E47B1B6F1A2EC8FA647FF0A568AB07165D747E93F221C7A2572593DD5B1BBFBBF15E40DE9DBD97EC18E0F9C56CEC5B035C22D1D8E8E320EAA01F2A514F14B28419';
wwv_flow_api.g_varchar2_table(19) := '78C15D0372D756B8EB7B711890D9C4C692401E73D1BDF09708AEB946769EAC90A3D1AB32AE6CFBBB4D0FDEC2DB16B0607EACF13097B45EA1A93898E9304412594BEEEAEAEA8625CF04F3AD5B363FB406F272FFB60490C7005313734B9525B660A3F5B464';
wwv_flow_api.g_varchar2_table(20) := '910A5832214F7733EE5658F2AD3868DD92AD011E26D11811D94D4B354DEAD34A023487B0C3AB562413801C8D4E03F31F6FD9FCF05A9C27E4CC7ABC6DC0E42D26B50638D7F2625A53AEB2C682E93E4BB829D4FCFA69C9218924BB34F0822567B6E1076F5F';
wwv_flow_api.g_varchar2_table(21) := '6616DE53B631265B039CDFEE40EDC38E42212743B6F830E52F0D87EDE378D70A8371177EBA3A59C2CE8FFE61F3C30A99960C5916A574A37A9A44A86E2A1D4EB4B72560C46D791EB42C3ADAD9216D8EE34C694FA5FFE5D1EF7CF3F03FFDC77F7D0857ED98';
wwv_flow_api.g_varchar2_table(22) := '274486D2286B8083EAA2D3E954ACBBA33B9C4AA5391D2DCA5A8602A07719378226A4A1788BF048EE4C9CFB90BFC106E0DED906F1CD1AE0324B66105DEE9D15C20C55849C48281212BC8805B7733DCA4661D92FEE9B94A5F3F7F9FD729BC96752E6CBDF37';
wwv_flow_api.g_varchar2_table(23) := 'E57A8EE17D128E2369681DC6E394395F4C6A0DB01148318D295759976F6581BB0E3B61859C3FF0997E99946DCCDF1FA8CD269F492F5736EF3CD63EF09800C78EEC55CC6B3206BACE40E7AC0559D4C2006F6C7E080FB18722E130A58B97CAA8B1E9719E1B';
wwv_flow_api.g_varchar2_table(24) := 'C64F2F319AD764F43A38882FD6000FE29ABECEEAE00D5F80DCAF2BF575C32FD3386B80F3DCCC652E159CC32309B235C0C1C157584B470A646B8039488DB42D1F7250FB660DF04872D1F9300D641E0B621FAD01CE17CA48DB379083E8A5C60017A88DF990';
wwv_flow_api.g_varchar2_table(25) := '8364C9D6000751BB0B649BCB46C815019B4259031C24ADCE111BC24ED02CD91AE021C82AB0458204D91AE0D1E0A2F335D240A600FDECBDAC01F67327F3C1D8DC0FC2986C0DB04DC105A92E63C9F4607E54F231C016B449215784F5B5F17E836C0DF0681B';
wwv_flow_api.g_varchar2_table(26) := '83FBEA05EF275700B2DF2CD91AE0BE1D1E8DDF0939E2334B1E036C5913FD66C9D600FB6DECB1CC6D50D5194BF683BBB60678B48FC17D35C02F90AD011EB3E0BE88F1324B1F8CC9D6008F59F0A701F388199329E872188135C0FD776FEC2825504E4BB606';
wwv_flow_api.g_varchar2_table(27) := 'B81CDA1924F5E1A3CEE5984259033CE6A2AFAC6E39C810D670198435C0C3D5E02B8BD1DF3914321E1AA0E0874366D6008F5970E18A95B3E461806C0D70E1DD1BCB49090C17E431C065D4B71CE4128EC9D6000FC77852461625BB746E4C2ED118670D7089';
wwv_flow_api.g_varchar2_table(28) := 'DA5732C1FAA9620399A9FE40D962E3AC011EB3E0E2A87890F15F32E1D15C9BB2B40678CC828B03CCD2C692C1D8DA66ED17FED65A34CA2B22643E5CCF1FFADBD8AC59B08DC68CD5E149406F505812C618604B82B4598DCD3178C4B868BC775965AC9168BE';
wwv_flow_api.g_varchar2_table(29) := 'B471DC08ACEF3953263F7BA1FB7DEB2AB45C21F92C0EC1620DB01162211DB096472F8A579861CCAA087B5D2134038EB30EBCC58E7FC4CDA425A3AF494221E409E18D3A1551BC966A901B854F954977A7B44ED6EDE7CD1AE0E1EE26213A001B06D8EEAE84';
wwv_flow_api.g_varchar2_table(30) := 'B4B7344B0A29682A821EA1EB2B0A25565D2BD178A51E0EE15D54A9AEA45C3C775A956130D6C8EBB27CD5B83AA9884473CAD4733D7FED59033CDCDDAA8844A43B999496332725565523D3E6CC93FAC953A566DC78896541760362477B9B5C6A6991731F9F';
wwv_flow_api.g_varchar2_table(31) := '908E8BAD12ADAC524BAE1A374EA6CF9DAF5313B578A3A1C615193DE993521932998CB49C3B2B780522948C223485865B0A57BE5EB000538E1038ADB6ED42B3842315B2F2B6AFCA82A5D7C894E933A4BAA6160F9F57E0BC37C52088542A050BEF924BAD2D';
wwv_flow_api.g_varchar2_table(32) := '7260FF3ED9F7F22F24D17651162E5F29B7DD71179EB67014588FABCD5E2407CD23CFBF193783FA23924C74CA0BCF3C2DBFDAFD82D44D9A8A37D3597929DD95690D2147B00043CA74CB17CF9F9519F316C8EAAFDC29572F5824553535EA9809D48CBF2A0B';
wwv_flow_api.g_varchar2_table(33) := '585B14BC42350205982E9D78DBE71BBB9E03F0A4C461C913EA27AABB6539BED7B7F7C6829E7B37C7F17A410F7032816BD6C2CD77F2791C11FDCF644D2E7FA581024CB86D17CEC9BC6BAE93DBD7DF2D333E330B56E54A175C355D67046E5B5D28C7C9AC9C';
wwv_flow_api.g_varchar2_table(34) := '75E90FDFBBBBBB25850FCFF31CED54C7536FC71BBAB3657848F3B01C94016F6457D854846834231D6D6DD2DA7C4E22F12A9A75B6943F93C0007610F5765E6AC5583B1F70EF9199B3672B58BCB813428FAA9B3D73EAA49CC6A70D632D11456331A91D5F27';
wwv_flow_api.g_varchar2_table(35) := '13264E9429D3A64301181465144CEBF973F2FEC126C1EB7BB5AC2A84210F25A0B5729B396BB6545657F305A139053AD4F45B39FC9BB7A57AFC4494F5B1F9A2FDD60097528F39D549A7607D8071CB57EF9219B366611C4CA805C600B1EDD245D9B767B7EC';
wwv_flow_api.g_varchar2_table(36) := 'DFFBAAB47E7246A36AC20963BC8CC4E2327EE22459F8F9EB146E45342EE1684C8E1F7E578E1D7A472D93794DA044FB66E0D47CEA98ACDDF0A7326BDE3CEF2CAC99E3FBD10FDE975D3FDD010FE0A2FEB0066C9AC1A77FAC01560B285127E966DB9B2FC8F2';
wwv_flow_api.g_varchar2_table(37) := '9B6F93F90B3FABD6440B8BC072DBDB2EC90BCFFE4C5E7D6AAB54D53568941CC1F8CA8D79A818674F7C24A73FFA502A6BC62B745A312D32DDDDD5ABC574D911C0FFE4F807B2F80B6BE4FA9BD7481C1139FE8714F512179ACFCB8BCF3E2DAD8801C63720B8';
wwv_flow_api.g_varchar2_table(38) := '42DD7EDFAC012E5547754C050C8EBF0BAF5986E0A852C7537E279003FBDF9257FEFB71A99F3957E170310364D11CA85C85A373D538A6518C743388A809971B23ED4814D15776635D9CD7722A3573C152F9F2D7BE2E0D53A648B2B353F3720C7FFD9597E4';
wwv_flow_api.g_varchar2_table(39) := 'D0BEBD523779062CD7BF91B3E91353DF036624DB856949FDD4193275065F82EE05470CA85A3055FAF56B7B243EAE1E1616038C0E9D0211A6AE603194E2D801D674EFDCA7CB8E5656AB7230E8D20D701DB85FCE6BBB131DB266DDB775EC65F0C6EB53190E';
wwv_flow_api.g_varchar2_table(40) := 'BCFD96ECF9F9D352533FD92BC2311AE7FCBE59035CAA3198169C46243BA161B24E6D6869BAE1784B73B39CF9DD31A9C6AA52275C752DA63D37ACFD7DA9AEADF5AC1C7934B796F1409DFCE8A8BCBBFF0DB556850E505CEAA4425C3A7F46D67EFD9BB26439';
wwv_flow_api.g_varchar2_table(41) := 'C76BCC7EE00DE8314E1C3B2A2FFE0F5EAB8FFA18A8E9BC17FB41D8AC012E657729D0EADA710872E096215542276846CB5DB0DA9A090DD286690B57B3567E69B54C9C344912B07A46DECC6B365AFDAFDE7C5D7EB3F7250F304C9B0E9B8B17CDA74FC8D21B';
wwv_flow_api.g_varchar2_table(42) := 'D7C80D1877197D33886300C70592979F7B46CE1E3F2AE37CBEA861FA999F5ABB5DA896925FB3B57D4E5918B156A895A969B16E00CE2D6C1038501126F3799F88A65E56EF0604AD921FB33112E6B8DBD6725E265F354756DFBE0E53AA060C09098D9869C1';
wwv_flow_api.g_varchar2_table(43) := '6FFEF25539B0F765B8E649280B75C8AFC054E4E3D41AE0D2F59137151C9DF3EA9C532D120B1948ABAA6B704728A6D1325D2CAD9ACB921C3BF9E1BE51029E338068D3FC4E45E84A766A5DB7DEB95E66CDBD5ACBE000C047E4BD777E2BBBFFF7298923FA66';
wwv_flow_api.g_varchar2_table(44) := '50A7019C5EBF74BDB55DB335176DBB61B9FA6071E17004AEF282AE2BF3698714AD10E9F80913748E7BF1C2792C3AD463FAF289BC04775A09F009B8EE5AB8F5EB6FBA45F3714D9A651870112E1738B023ED5819BB75FD3764E9B26B7555CC8CBBA74F9E90';
wwv_flow_api.g_varchar2_table(45) := '179F794A03B7DAFA066F158C8503B659035CAAAEAB1BC558D87CF634C6DC8B5287408A1BAD697CDD0459B86C853CFFF8BFCBCC45CB100177CA1BCFFF4C5797DACF9F92599F5B25CBAE5F958DA07B7C33AD9F8B19ADB85DB864D56A59B57A0DA26B46E19D';
wwv_flow_api.g_varchar2_table(46) := 'B81315D73B507B763D2F27DE6F92BA299C12619A86F13C9FAF2E5F6A44E06FE2D600F788CF7287616511AC3E5DFCE4B4FCEEE8115D7FA6F5D122190C5D77E397E4D87B07E5BD7DBBA57EC65C9938738EBAD7F649D3A576029481568B3A34CD362D8C71B7';
wwv_flow_api.g_varchar2_table(47) := 'BDB55926CD9C25B77CE50EDC74684050D6A1E5E8D2DFFEBF3DF2C62F9E952A7805AE45133095C2F491CACC089CC7FCBEF97E0CA63BE54A1697170FEC7B4D5A5B2E28084223E4C953A7C99D7FF2E772E3BABBD5ED5E40347CFEE471397FFCB08255579C47';
wwv_flow_api.g_varchar2_table(48) := '815078BB904B926BEFD8209F9933579280C8319CF3DDC3EF36C94B4F3FA1632E5F7096C218EDEA224937FE1BBC6E2C96605CE70A169526009B350B2EA52E73C9B1AA76BC1C79E7D7B2FFB5BD72F3EFDD0EAB8EEA122265CCBB4A7FB0E11EB9EE8B37E12E';
wwv_flow_api.g_varchar2_table(49) := '4FB31E679034B161121E0018A7F359650128B45042BBED8FFE4C962C5BEE05613846B8298063E076D77DF7EB8D052A57FEA68119F3618164DF2F5F9143984FD7D4D57BC1577E461FED5B035CCA3E7956EC481C9019D5F2A98D6B57DDA88B102662AEACAA';
wwv_flow_api.g_varchar2_table(50) := '96790B3E9B8D9ACD98090B040C5A3A2D99D0994E9E355F3E77ED0A559204A6443CC6089D3CA92CB4EABE70E9E2A9689C3377C1E23F38745092F0040CC0A041A5EC7E51755B03DC5BD78B6A53BF85F5E602C64E2E5B3EB7FD47BA0041C89CB752F86940EC';
wwv_flow_api.g_varchar2_table(51) := 'C6CD03BA607E180DB34DDE9A7354EBEC686F97B3B89DC8952F3E24C06912C7F1BE6329EF31F7DD4238C6C30CFA14FEA7B3F42DE28BEFD60097D2451B4971813F8AA5432E44ECDAF9B81C39D4244B57DC8075E339980AD5AB4533AF7743C1B3B84B58C2BC';
wwv_flow_api.g_varchar2_table(52) := 'D4DA2A673E3E251F1C7C470EBEF51A9EDD9A26E7CE9C5625300F01986B0C9452C9A8149C5F7776B44B05D6B595FA4085CA7CCE1AE06151E8ACA5463195A1BBFDF0C07E1D97EBA74C9786195729E42884CEE08816CCE5C68BB821D17CE694B4F03E311EB5';
wwv_flow_api.g_varchar2_table(53) := 'E1037A6D587EFCF94FB6691D46190AE3C005162CA800F425047BD57513D5731456B63CB9AC011EAEE6ABFBD531352CE3264EC673515DBAC071FEE3130876701709E3A96EEA52B1A0018BE37224ADADB2B60EA7107DC3959F3E7EC49BFEE44F6E7B75822A';
wwv_flow_api.g_varchar2_table(54) := '9BEF97BCEF74D16C039FCEE40305A5B0609BC61238C0644001D38AD259975985A04B87CD2C544244269D0A690A4E1C37A90026606354AE63EF20A4E921D6DA717D06658328DC4B7906FE92AF5603E7BCF2D94002D66E65A5C04508171F8545A4463A049A';
wwv_flow_api.g_varchar2_table(55) := 'BDB96F40308F97CF5B09BBB278829FC31A6023D76117895AAAB9AA17E99A6F263550CDF7D1945A5BC92A8DB31A4D287AFA6A5396D60097CD827BE43262F66CCAD21AE01123DD11D6116B806DBA951126E3B276C71A609B6EA5AC12F1C1C56D1A8B35C036';
wwv_flow_api.g_varchar2_table(56) := '1BE5031997B509368DA528C04D4D4DDA163E028E9D31C696D48282348FD51B190FB5EAA2002F5EBC58A13A6E38849D9E471E86DA9AB172390950A6FC62649C3B31C89DA2163A8C76654269179AC285429A712E51BB1E648306CCCE2EAB4A0D98ABFF93C5';
wwv_flow_api.g_varchar2_table(57) := '94658DA67CDFB4FFABF53E5A681998882EA522A14C59899171EF0A0BFF5614E0F5B80E9EF797483874249D09BD57198B2D6E4F24F86B6AFC63AF4AB015536D3165D91553BE6F5A48372F538614792AABB719C830DCD199783F129623ACD6C898FB43D9CC';
wwv_flow_api.g_varchar2_table(58) := '658752968DE2D2AFB66DD37D7FFC8780FA83782CCA5B360AD8347E489597B890DFDAA6BE0F7D4E2493AD68DB7DDFFFCF6D3FA508B09F93F150445214E0BE0DD8F4AD6FAC7442EE3A2CF303B2C35F858C6D054B2083BBD84E4BC60D3DF3FD1FFEF84D162B';
wwv_flow_api.g_varchar2_table(59) := '166EC1972E2063D18A52C035465B162B32FD7FAB897B28B8218F360000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72348872133797168)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/gz.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000015F6494441547801ED9D6B901CD575C74F4FCFECCEBE57ABF703047A20092104086416530A129290805079B0FA902F8913571EE547AAE20A552176B1';
wwv_flow_api.g_varchar2_table(7) := 'B1C072912A2AD8E5CA075C29E202C9D1265F6C3024C22063F4964C904D49982084D06B05ABC7BE77677A3AFFFFEDB9B3BDAB7DCDCCED9DEEF5DEAAD97ECCEDDBF79EDF3DE79E7B6E4FAF8889E48A65A2989296D1DC1C93C9D08E21428C0F39CEFFD0752D';
wwv_flow_api.g_varchar2_table(8) := 'B12C9717AEFEF9136B5D893D86C37A082B1366ECA871C6B1245961D99FCF28AB7CE1675FFCE6274DB7EEB65BDC6DACB76A4FFEC208DF15C5699E0FEE9D6F3DF1782663FDD0AE4DD6A9665AC5153D3E51914361F7B15C571C5C5D25B6D4A463AF8BD87FF3';
wwv_flow_api.g_varchar2_table(9) := '7AE33F9C7EE0ADE6F8DE079A9DC902B930E964A5DFB41B3D7EDB3667CDDB4FCE4DA79D3DF1FACA95E9AB5D297C1DF3045F3880EC2DB29BE1CA19EEDCE0ABBC239D4F6F711670513F2B236EA62A9EE869A8AEA9C9A49C03E2A6FEE4F5C6E6490519200A4F';
wwv_flow_api.g_varchar2_table(10) := '2DD2A22E76D2A945D859E6B4F7407884CB8FEBDB72BF988F2ECF5FC670E7FCDFEB7D9D4F6F71DEC23E0616D4530D5180DB595657D928B1C4CB9B0F6DBF79EFFAE6F4037B9BEDC930261342E1A9692555415C2B86514B8DC538A26D8EC2278B18B69995EE';
wwv_flow_api.g_varchar2_table(11) := '6FEF71E355C9FB626E6C52412E0E70CBFBCAC45B6E06FE27DC96A20C3EBBCAC4A7ACE18607ED5AE98E5E275153D148C85BF76D5F4C4D6E92DD91F6AE8B039CD560CFD24183953E4F3C2403775446883A9DEAE871E2D5C9463716DBB5E9E0F6A52DD63627';
wwv_flow_api.g_varchar2_table(12) := 'CA908B033C48B211545F5D7FDA1E764ECF7FF034B9B6E21E1B9AFCD0FE1D4B0839AA63B241C0D1555F8517FD336B839403966A8726D724EF81AFBD9390A36AAE0D028EBE06FB5AA020734C569063995D5B8E6C5F1645736D10700435585799069A1AAC4D';
wwv_flow_api.g_varchar2_table(13) := 'B6B7F52077027275F26ED789FD78F3D1EF2C1F800C7D8F4032083812ED1D8C445739EBFFEB435F26CAC74A0372A23A79879D7677E520B7B428CFDB973794BB060187B27DA3574AABECE8FEBF0719E6DA2664C7DDB5F1C0F6158CE0354500B241C05A5AA3';
wwv_flow_api.g_varchar2_table(14) := 'CB3454DFFA5516D51FA5055973DDE7D855C93BE262FDC7E623CFDC1605C80601870ADDF82AE3270AD87EDEC31400592118C231B9A662959D915D9BF7851FB241C0638867188995FC94BFCAA36BB0AE2AE5A5E6C9D0E4DBAC981FF2B6508EC90601FBD541';
wwv_flow_api.g_varchar2_table(15) := 'CB2342DBB13558372637854AD47890B71C7CE6F6966D2D189301990F0E842819AC8C5F1D42D4C2F1544547B2C693D7CB13C3242906739D266474ED1F6FDDFFED3B15E45B119F0F1164838023ACC1C3CF8347C59D55785B41AE4EAE702D7BE7D6FD3B4207';
wwv_flow_api.g_varchar2_table(16) := 'D920E0086B701665012DE02536225E6944BC96BB086B6E3DE2416E7E0ADF8440930D028EA006FBAB8C7DFFE1A8EAABBFF42EE0A3034A93156427B3EBE1434FDFDD6C3567C200D92060DDEA086DFD2A8B7DFFE1B85AC10B3464ADC9D5C96578366DD796C3';
wwv_flow_api.g_varchar2_table(17) := '3BEE0903648380F316CFB864382199F277B206AA35D06C4F933D73BDC4CA645EDEB2EFDB25876C1070DE066E4048A5DECB3A5906AA91838CB0E652CBB6B19EFCF4DA526AB241C0035DD980A026B6886234F8FA9AE6C664044396E271B55D5B0E7DA7B154';
wwv_flow_api.g_varchar2_table(18) := '900D028EA006EB2A9BD3608D9BBDDD4E77C1BBAE4E2EC2F35E3B4B05D920E0086AB0AE7276B950D331B4F520231882A7356F2A156483800D8965228BF16BB0DE377BFF014D26E48CBB6BCBC1A7EFA7B956B7998079B241C0C148C8ACBC8794A635387B3A';
wwv_flow_api.g_varchar2_table(19) := 'A0160C40AE4E2EC4E3C53B37EF7B7A1D82201302D920E021C28BC2A19F28300CE16DB20503902BCB6F88D9D64B39C84F3DE536BBC12D5018041CA0784C8ADA5F96BFCA80EDE7EDCF6668DF83DCD98731D907193F186896E0201B041CB0780C4979C46220';
wwv_flow_api.g_varchar2_table(20) := '7E3FEF11F315F745760AA521E3B9EB83CFACE7AF429A057A1C80261B045C5CCB4B72B5BF4F06AFC1BA891EE4AEBE143479010E5EDA7A68C706F4AE4034F9771BB056594E9326468307208B154F75F512F23CD7CDBCB465FF330F06A1C906016B69E93644';
wwv_flow_api.g_varchar2_table(21) := '609BD560F58B86A11ACCEFF2F9B0B963E517EF4D08DE60EFF227981AF25C89593F7AE8C88E8D4A93318D6ADADDC45F3D169D0C0266EBA29994F2F28F3FE0C1FE9ACF874D1F2B3F7F1CA3F3A91DE8AC4822ED395EF32CC7E16FA1B6F02B3E1D62623DD920';
wwv_flow_api.g_varchar2_table(22) := '60AFC651FB0BA850A558C682A82DDBC2164FE38CE7131B67BEB1CA623931CB767AFAFA13D515B36CDB7DF1E163CF2AC86AAEECEF740508B7F897B0E46EEA75CEDC61D87760700835ED66ECCEAEAE5E98CDCE9257B9A3BB33168FCD7652CE736B7EF6F71F';
wwv_flow_api.g_varchar2_table(23) := '1E7BF89F3F6A6A698AE14D0A7C9D4841C920E0889968F44776C97ED729EF4FA56CE949E3BD3B19A831CE0ED71466D6E7FDFB5AECFE73FE7D7EEF3FF6EFEB6BB379507C02CEB4030BB22216B316E0F4472DEA37D8DEAB32FCD9C7BB6F10306B1EB1048942';
wwv_flow_api.g_varchar2_table(24) := '8B2D298B2714D89E3420E224DE483140936D1A7AEC3FA7BFD35BFF7743F779CCA4F30EDED205B3E27171D34EDA4DB9A84CF1C92060D42E6A49CB9754137447E0B82AC8081353937369B8B6E97343B7BC489F1BBAAF0BD4DF0FDEE28E78F18F6B636B79AF';
wwv_flow_api.g_varchar2_table(25) := '8741FEEC6B32F495F96E0D3A597E81E45B8D12E6F7AAEDAD082720DB24AC24B53AA3264FDE793A3A13F0016E551B8D5D4925F79A8CC264641070611508D555942C353999F0CCB47A9F56A86A9877650C021ED4EFF2AE48A82E9844900D020E15A2E22B33';
wwv_flow_api.g_varchar2_table(26) := '49201B041CD13178B4AE5006F15468733D5AC6F07E6710F02432D19A971E9315649C0C7A4C0E408406016BA94CB2ED20C8B0520140C8492C002338053827DD5176AE831C10E5008A35083880EE378ACC27FCAB1C64C48618E90AC25C072042838003E87E';
wwv_flow_api.g_varchar2_table(27) := '134E718C1BE6206BC7CB709B0D17C7D618043C867026CBD7841087D872DEB5412AE1D6E0006A17E64EC179B2828C6D10E6DA50DB0D6AB0C19E6CA8718116C3E62AC806C7E40044681070A0E20C67E139C8018DC9065A3D05B858210E825CA4B90E609433';
wwv_flow_api.g_varchar2_table(28) := '083880DA152BFC89BA3E07D9A0B936547783800DD528AAC5E420D35C17A9C906653005D8A0305518D3B4E35564FD0C0266179E4A39C895E170BC0C02FE1D1E8387F66BF6750643F2851C808E18041C40ED860A2E4AC785400E40470C020EA07651023A5C';
wwv_flow_api.g_varchar2_table(29) := '5DFD906D88BA043A6010F0702D9C3AA7A0EAD8351F881D2DAC19400730083880DA4D96FEA134197019BB569A3C82AC02308206010750BBC90298ED182F64C36D360878845E69B8C2912E8EEFD5A1991E4B930D36D220E0290D1E938B16517C04C801E888';
wwv_flow_api.g_varchar2_table(30) := '41C063366F2A839600357938C8BA03E87C06B653800D0831EF22087282C664838003B02F794B2E62175C07D97CFD0D020EC0BE986F6FF84A1C04193234AC2706011BAE59F8500457233F648ECDA30543F2AC85C11F804F69709EB21F9C5D4FA1F0B20149';
wwv_flow_api.g_varchar2_table(31) := 'E3206546610C021E5CDFA9A33C2540FDC86932B024F3BC7E84EC538047104CC94E1332C399861E59373806974C2493F0C666CC330533293498E2C0FBCC1468BE74527B03DE79EF3B9EE37F95D489DFE18D27FA30EFADFA0F95795F35DE0B06EA39DE2B46';
wwv_flow_api.g_varchar2_table(32) := 'CA671070E1C21AA972639DD700CB002E69C5955173002D93F5426378978A0691C2F93E37A3A0F23ABC3749AA708DF7DE139ED1421D6E5F9FF3B6EC4CDDAE232C535F35565D4BF5BD41C013DB546A5F395E7B548E7FE2DB9E49C931A70BAA3AD2ABA52C99';
wwv_flow_api.g_varchar2_table(33) := '192B93F9B17225671B58AE20EFB1F4B53CE5CE367A9017DB9552870E920E39648380F3945581D9295EA66A0897608FA63B607BCBE58F9273E5A6F2066948544B7516640FBEBF96EE91B654BB1CEF6F935FA5BB64254053931702D083C979EA8D49AED278';
wwv_flow_api.g_varchar2_table(34) := 'C0D37D34A7B0D8D1EFCBC22E35975601AF3F9453A9ABD2EAF4AA0EA6EBE4D52C5C7F23059882A45798B46C3990C6AB256371F956C317A471DA325958395BEACAAAF0AC5B1C2B72DE9B78330091CEA4A51FA0DBFA3AE4EDCF8FCBF7DB8EC8C7995E79BC76';
wwv_flow_api.g_varchar2_table(35) := 'B97C69E166E48D89837C9AED887890811D81E577A5FBE4C54FF7C877AFBC2BF726EAA507E63AAC29328035DC32203E986E87C6CE97BF9CB75E564F5B2CB5892A058840B5B34581139A6B7384B6E486AAD900D3239FB41D82779592EA78526656D4FB005F';
wwv_flow_api.g_varchar2_table(36) := '8F589DC96A30F739B62700B8DBE993FA78150A4FAB319EF70A6B8A0C606A2EE11E763AE4CBD54BE4EB0B1F9125B5F3A15519E983C009B1CC4614085B82E631DFCEAC7C6A8049392968721AF1034BBA494B995CB5E1EE90C4337CB99D2BFD69BA529E33C5';
wwv_flow_api.g_varchar2_table(37) := '721D74988E54B79CEFBF8A2C09A15317E61419C084FBBF996EF9438C9B5FBFE911B9A56681F4A6FB311E3A9284D01DF8C7A73B2FCAE9EE8B72B9BF538DAD498CB733CA6A6476729A2C8006B3037413885526E731861E6BFBADD260821B186B01135AEB59';
wwv_flow_api.g_varchar2_table(38) := '034B6EA95D20B5F10A987A07DACB77965A72A4EDA47CBFE343596D5723A2C81863789341C0C1F46496CA294D37CC613FC6CBBF9EBF4196D4CC971E682D0D7245BC5CAE00E86B170E4B4BDBAFE497F08C7BDC94A79A188B6F8696AD4CD4C9E6BAE5E24073';
wwv_flow_api.g_varchar2_table(39) := '6F8173168FD9F28BAE33F2DAA9D3287920F15E9C5655E23EC7526DF22F7336CBCABA854A47A9C534CFBFB9FAB1FCD3B9FF915A1CD383EF452DFC650C94168E3D83808369264D33A735BF71BAE5C96977C91DD3968A036DE278580E8DBA96EA927FFF648F';
wwv_flow_api.g_varchar2_table(40) := 'FCE3677B41A74A6E85D656E03C531A79DAA1DBAFF45D92572E5D9425B10A4C6D6C49E3BDBD7DD0FC0E7C3CF3EBD59D47B3D0218EF55F92BFA85D25BF3FE70B5285B1BAD7E95756A2B5F78ABC70F60D792F754D1AD16938170EA6D5AAFA46FE18046CA43E';
wwv_flow_api.g_varchar2_table(41) := 'D715428DEA879608B4E58B0D2B9473D48FF1348E636AF02F2FFD5AC1BD333E1DD3A3B8CAEBD00AA3A472FC990B8D9D1F4BF2C5DF0A881E33CB01FAC66C47E04D595625F29E4E77CB868A1BE42B0BB7C8FCCA19D29DEEC55BBA6DE98363F693F307E4858E';
wwv_flow_api.g_varchar2_table(42) := '93B2365E2FBD30CDD4F829C0945E11891A7C3ED32FEBCB1A6451D51C5512B52E0E389FF55E959FB6BD0BCD4D4A0D8E5B337DF241A607E699E3A2167D1643D61B9E060DBD095A4E3C5D30FBCC9541169ADB4B983E9D467CEAF9790FCA528CBDD45C3A6936';
wwv_flow_api.g_varchar2_table(43) := '4D7AEBAFE56F3F7B475662DC65E9EC28FA0EAA5221FD6350832948F3891A7C1120B6964D934A984B2F28E1DD8780F7F7B6C2D9A992D3007BAB5D235F9DD92875F14A68ECC01446D78C5A7FA2EB9CBCDC7E421A3816A36CCE601380CF71FE183CF4EFCDD9';
wwv_flow_api.g_varchar2_table(44) := '24F7CFBC0D9DC4554341452229BF6D3F2BCF9F7B432A70AE868E5A044CB32661107030FD59950A8D9C817927830C7ACCE4B62DD529A7DC7E5917AB96F710D1DA8468D6A373D6CAECCAE978717B2F7E876DC369CAFA5B004827696FEBBBF2DD6BEFC974E0';
wwv_flow_api.g_varchar2_table(45) := '555129E82363D2EFA42ECB57EB30EECEBD572AE0957723984107EE3202243F3AFB96BCD1D78AA0461D4C7378831A1AAA7FCBF61B4A5A4F0C1537A81857CA300E529B75E2DDB874407CFA2CBF4F002AC74CEF8333CC08CD53661B5BBF05A099AE215C44C5';
wwv_flow_api.g_varchar2_table(46) := '7EAF7C96FCD9FCF532A7A2011E7ABFEA0C29C0A477FEDCD5E37257BC0653222C64A0387D3FEC863E19041C4C5BBD6E6349179C1C86147522CC5ABB02D395B8123CE7B10E00F4010E3FBD18B7FBE08CF11A42A5D74DA0BA3CEE57A0235C463E5EFB8D791B';
wwv_flow_api.g_varchar2_table(47) := '6539A6447D985B1360C28ECB51CC779F6CFD05C6EC244CB8AD1CB828C1A5AC0C9A682D7AB35B0504202EA53A545C998106CF4C8BCC2CAF93B5309B1F61316105A6481F63FAB2F3CC9B084C544A1716026ACBAAE51198DC19C8C79834E12840809DC07B34';
wwv_flow_api.g_varchar2_table(48) := 'B091935885FADE9C8D72FFAC553846EC1A5A5B8571F763044DFEF5DC9BF2191CAF25F15AE9540E19EFEDA5A88036083898261326831527FB2FCB5504346626EB9584B9A2331DFB5BEB57C8372EBC261BCB17481B021CDFBA72D033C94EA72CA9BC5936CC';
wwv_flow_api.g_varchar2_table(49) := 'BA4B8DB55A77D5C5E8244918FC7DCE35F95ADD6DF2D8BC4661D48B53228EBBED0845B69C7B47FEABFB8CDC9F98260CA93092E64FDE0CDA7F269CFB0601EBBE6DB6A134CAD331053A8AD0E2898E4F6531E2CF3178C3D4483A435B67DF2D873A4ECBEECE13';
wwv_flow_api.g_varchar2_table(50) := 'B22C315DD62566C0F4C6E52C347329C64DB05449C5A4B1A72DC20174800D6533E54F176C50A14CC22D83134693BEE7C25179AAED00BCF22AE9C4D0D003C05C9FD22D6491F408E8A4853D19041C4C53A929EA590D40FBEFCBC7E5DE192B64763996E830CE';
wwv_flow_api.g_varchar2_table(51) := 'A600F9C6CA59F2E4A23F90A5E767C8CEF693F276EA0AEC30B40D0017964F5720FC35535060BE335833FEBBF99B6445ED8D6ACC6607A0D77DE4F207F2A5D63751862D9D28E78CCF34132721334EB6180715D80E780538086132083898DE4C81723D670D16';
wwv_flow_api.g_varchar2_table(52) := 'E85FEC3A25F75D3C26DB6E7C408529E94CD1722E456CFA2B8B1E95473BEF96CF3137E6427F39B47176C574A9C738CC85022696E5396A69F9C1ACCD721FE6BB5C54E0876BC8EC309C43BFBAF08F55F974C47462EBE8A8318ECD55A99FB61E96E719D542E0';
wwv_flow_api.g_varchar2_table(53) := '83263CACC920E0609AA8040B41D36B5E8E58F237E1D536246A64E3DC352AF0C168133F3558F159DDB044C1A237CD857C5E4B686915F48829134CD3BABC6C96AC9BB90AE32E82169C2F23AF07DE550B19CBA1D583C6EC6CD3F47A303DF477AF7E2872AD57';
wwv_flow_api.g_varchar2_table(54) := 'E270C0F88448589341C003BD3D88C6528B3967ED8370BF76F6556986E7BC69F61A8C9F0D00C41F0338C21835B1D20C6770CC1AC5A1995C94E0DA309DA7D3DDADB204632B1F12E09C99E3383D737FA2377D5D527938E746A974BF551A7CDD75D784E08441';
wwv_flow_api.g_varchar2_table(55) := 'C0C13696A5D314F2E1B93644AFFEEAC21EF9F3F653F250C32AAC0DDF203392756A214219E32C0082BA8AD5A62BFD1D72A6AB558E5CFB3F79E9DAFB723BE2DA9FF67CAEA64434B704CCF21536752D8E86690ECB63348DF36B3EEB85FF24891A69D821A039';
wwv_flow_api.g_varchar2_table(56) := '4C150C020EBEA194792FA2C7D3B1605F8B40C4BF757D84CF29590760B797CF94B9895A29B7CB15302E29F662CDF80234FD04A6587BE1850BB47F2E9CAB0B885C3DF7C92B5860B81E90C7957F3D234DF46C9937FBE616D601672E605E4E2F3BECA14B8380';
wwv_flow_api.g_varchar2_table(57) := '87E93E019CA2807B00390163DC88F1AF031A7804018EB7F1D4646E15495102164526A6A250CB60A6EB314EF35437AE79B5E762D639F2908EBFAA1EEE5B6049AA60FE6931F22D61EC7BF11E6652E400B3D91C67F93CB27A5C0742BE2356A93C5C8E9CD43B';
wwv_flow_api.g_varchar2_table(58) := '0F81978FC2578B0A30BD7CFA82DA1787495E0DAFDCC6B63051F28101AC36E16AF370D94273A54612B05F047C1880C226748AC5FBCB1C70BC144E6F7AA3BF633E4225EC02E9AAB2BDF2D46EA8FF18046CAED7E523310D8ED7109C5F837539843A345D7F66';
wwv_flow_api.g_varchar2_table(59) := '688EC9713C38C05A549B0A337645DD72848BA30FCF9C2C0D028EBE5847E82F25386D4E96060197400E53B71C530206019B332B63D67A2AC3B8256010B039B332EEDA4FDA8CE694C5206073959AB4DCC6DD3073CA521CE096F7B335E10FAFF1789BB97A8D';
wwv_flow_api.g_varchar2_table(60) := '5B14932E2365A8E2E1D91FB3E7645C584B8B03DCB452A9AD6B613DC7C57ACD94121746C17F156508C8AEC33532A4AC8CD57E017F8A0B74647B97E562A5D48A21C6C0DA797F0AA8CBD4252A4EA308BB96CDDF5B209552839BA449D5C18E274E61E703BB16';
wwv_flow_api.g_varchar2_table(61) := '0FB170B1453DC962613BF5195B069417E5842D64A76448597A3285843D192B4117F0A7B8519366D9528F96CBED6F3DF1B895B17E68D762619629BB408E9D02AA351197646DE144DC6A3CF750860F8F1475F45E732DF7CBC7D73FFB9FEA329F8CC753CCD0';
wwv_flow_api.g_varchar2_table(62) := '3CC54BDF5781D53F7F622DC2FE8F81793DC6E370FF7076A8244A79ECF5B5184479D54A647EF2DEBA670FABEAF8645BCAEA71E428BEA394B605E1BBBB2199FE3FE86AB6C90C1686510000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72349300162797170)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/gz2.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D0000187D494441547801ED5DEB8F24D575BF55D5AFE9E99E9D65C1B0BC0C0B18CCA298D8C10E444A6C2345892C3952E45D45CA8724523EE5532C2B912245';
wwv_flow_api.g_varchar2_table(7) := '62ACC88680E27FC0F91009D8258C3F44F9904879C82891B11C11F3CA1208FB823560CC3E667A7A1EDD5D8FFC7EF7D6ADAAAEAE9EE9EEBAFD9A9DBBDB5D55F771EEB9E777CEB9E7DEAAAE11C2400A026119203355122BC18ABD1FC69116626E608220B090';
wwv_flow_api.g_varchar2_table(8) := '02127EF99D6F7E31F0ACAF236719977E6EE2696E4D5E5BC207EF15C72A5D3E54AA7DFFC1637FF95E10BCE80871D2B72C21C763B2BB69D12AE4E93809EE8FDEFED637025FFC6D7DB97288347BC0EDC9087B4E8B32598F65BCCEAA93CE23B9745B9D97ACDB';
wwv_flow_api.g_varchar2_table(9) := '450F057E49F89DE217DEBEF8CC9F58D6C90B3FFCE14A210856BCFD0272522414C75029084E3896B5EABDF2D69F1E6D59CEBF2EDF503DBE7665B31358C2B6206DCA55CBB37F47BA16BB56E7018EAABD3EC6D8E9DABA66BAA47FDBB8A53A83DB0902BF5828';
wwv_flow_api.g_varchar2_table(10) := '6F2F2F1EA9B7DAEE4F8A22F8BDCFDEFD171709F297BFBC3F40B687423455797555656CF9E21830B9BFB1B62D14B8027403801C741D99D7FB517555BE6E973EC6EDBA690ED356D7A5F2F19CBA17C05A85D5EEB8CDC3CBD52FB9C27A1E967CF757BEB2E2BE';
wwv_flow_api.g_varchar2_table(11) := 'F4D28AB31FE6640E74E474E2C4711A0324E65801FE21D1F220B879F82856C1B34D87B1BEBE1DD4972A8F7502775F819C0BE0D5D533D2F33A8E0DC325C223EBCAF41AFAB063E828E3894663C7AB2F2D3CDA09BC53672E3D792F2D59881765D9F418CCD773';
wwv_flow_api.g_varchar2_table(12) := '2E80B5059305CC7D2A94CEC7CF445AC3F5C60912806206B68A1A24C84B87167ED577AD53AF9EFBABFB1078792FBDF46DB86BE8F01CA65C0027C72B9D73326386CFD39E46CEB5001D9E9AF333DD352DF991825D7C3EB6E4D5B9B4646300278D6286B1CD64';
wwv_flow_api.g_varchar2_table(13) := '8D16CC900BFF390C0972A341902B8FD092DF3AF7B4B464210832ABCD4F3206F05C8D3A854F066821C89893EB95473CC77FE18D0BDF7D80EE7ADEE664630073FD39AF495A702FF30AE40D09F2E7B1B43F1D833C3FEEDA18C09C83E725A55531C382F55062';
wwv_flow_api.g_varchar2_table(14) := '4B5EAA3C6C0967EE403606705A685A42B378EC52452C93FA58B0665D82BC812554AD5E06C8F60BAFBDFBD471BAEB553927CF76746D0C60159F6899CCD1713009B096D5A4BB5EAA7CCE295A2FBCF5FE330F9D9C0390071BDE407875D9C5402DA656693477';
wwv_flow_api.g_varchar2_table(15) := '2341969B21F5F2439EEF9F7EFDEC7714C8AB276776096510E0A9C1357CC7A3EB623C27D7CA0F59B67DFA755AF2C9556F7546413606F0E8321B1E9FDC2D46B360DD6D1C5D2F2D3C64F9DE0BAF5EF8CEC31AE49595156332D51DE639CE143379063254DB94';
wwv_flow_api.g_varchar2_table(16) := '36EE1245F7234B90ED6673C75DAA578E3B5842BD76F1C95F26C80F3E78C69A25908D019CCF28FAC97102F97B47D1FD98E0FE97D35807C84B0B0F38813875660641CEF5444772E429A34816CDDE39B551339C4FC5798754817C68E1016C6F9E7AEBE2D3BF';
wwv_flow_api.g_varchar2_table(17) := 'FFE05D7FFED320380ECA2B36AC192A34BD946F7809BEE76A274B834BFEF3885FB9AD18645832A2EB17FEE7DC938F58D68AFFC4138078CA73B23180639348A03EA3A79873E3944702B1A24420D70F55EEC38DF153B302729EE1C5429AB333B8D5AE344290';
wwv_flow_api.g_varchar2_table(18) := 'D5D53EBC48827C2FEE493D3F0B201B033825B32C01CC6CDE1E5B95C3F01D81BC5857967CE6C2335F9AA6BB3606F0305298B5BA862C580F4B828CBD6BB7B654B9D717DEE9372E7EF7D169816C0CE0B90AB23414E1D1A0056BCA31C8F5CADD7820E8D41B17';
wwv_flow_api.g_varchar2_table(19) := '9F990AC8C600DEA7B70B3560A31C2390F1D0C05D020FF2BD79F6A9C7266DC9C6004E06A6A34863926DBAE285D1373A06615982DC84BBAED7CB77E169ECD36F9C7FEAD709321BF3F7508310C953C76007F304714264062590A09A3CA573739A8D16E7E43B';
wwv_flow_api.g_varchar2_table(20) := '51F03C41961B20DFC64DD631836C70785D76911CE0EC9D4F5E1725C80CBCE0AE6F87593F17812C9EC013B9E3B3648300CFD12DFFE9E8A29A9337105DD74A77E09751CFE119AFDF4026D46D7C201B0398329B8EDC66CF41ECC2919A939BADCE62AD72076E';
wwv_flow_api.g_varchar2_table(21) := '48F106C557C709B23180E7C87E7791FF448A600756611320D76BE55BF18389676390578CBB6B6300CFD9F3E05D481ADEE8E8A29D7DC107F5AC4293965C07C8C27AF6F5F7FEFA71B51E370BB23180E7D93D8377588E828207F9C117F3A20FF393D7E9735D';
wwv_flow_api.g_varchar2_table(22) := 'AE8FC9F2300FA0CA6EE4177F682B4401D175A7BA58BED5F68367DF3CFFE46F12642EA35E7CF104DE36903F1903782E77B2004298383712651E642CC193AE0FF3D379C96B5DAE8F1965E841D1475998185D17F1B4A65BAB578E829DE7CE5C78F2B758C6A7';
wwv_flow_api.g_varchar2_table(23) := '434CDC6A3406B0128BE67BC68F1A5806B0D04C3C3C87F77260B1EAD8BE6DD9F8E5FA043F36FAB21D67ABD96A2F2D556F02337FF7F6A5EF4990B95686B5C7EA3082588D3DD13142DFD36B0291D14D12542F709DE6C6C68E2F82E6F418523D379A1B4DA7E0';
wwv_flow_api.g_varchar2_table(24) := 'DCDC69BBDFFBF757FEECDDC77FE59973ABAB276084ABF84DD468C918C0B9D46C34DE73B552FC62C20BDCF28ED772B636BDC0F769C82CA189278FC9AEB2CAB2F2926DF479BF7A617E208A70281E3CC867A17DB7A3D539F51BECF05D199ACC104763000FD1';
wwv_flow_api.g_varchar2_table(25) := 'E76C54057EA1155BE54AB1C837396C6DB922F0E11325C86453A94137C33A4F1F93F59279DDADD4952ED7475D475D939F52B1203A6DCF156E80B70BE44FC6009EC7208B3852A83E66BA62C9165551105B9B1D05321F8CA5613151FE19E7CC52D0B0D270A9';
wwv_flow_api.g_varchar2_table(26) := 'A7AD22042712307A46E8A5E8E9D7640C473DAE6D2CC89AA7DB85F1F021492558AE5F2C806C2D5469CC9605413304531F94659D834E9C3FE4794FDBB00FA93109AD49BE2623C9F7A0E7C600A646CE7BA23517CBB600C882EFEC8816C7931E9841611A0338';
wwv_flow_api.g_varchar2_table(27) := 'F661939686E1FE66056443C3320870C2AF18626E6A6434C88B53B26483A23408F0BEB161A55700B984C06B615A201BD26E630053E90C2A9EA1E1E52323972D730EB23180F799FD469A31EF201B0318517E2494FD76A241AE4A778D575B32634E923180F7';
wwv_flow_api.g_varchar2_table(28) := '2FBC0A49625AE066C862014B28808C1DAF7948C6009EC79DACA10102A672C78B203B63B46483BA630CE0FD176265C3DF63C9E370D706DDA14180B305B22F73B525D7C66CC90684670C60834A676058E327212DB918CEC9E374D73987620CE09C7CCC6773';
wwv_flow_api.g_varchar2_table(29) := '587281205767D7928D017C5D0459596A4890C3E81A8FFCCCDC12CA18C0F37ABB300BB3A1F33827C39217105DCF1AC8C6001E5A28FBAC01E7E45904F90060838A368B201B03180A7C9020815903D918C0D7DB3269376D9E25908D01BCDB80AFC7320D32F7';
wwv_flow_api.g_varchar2_table(30) := 'AEA719781D003C46ED23C85C274F33BA3E00788C0093B4B6643E1932B0251B0C680E001E33C031C8967CFC6720900D063407004F00E024C87C6840823CA1FBC9C600BE6EB72A8750101F2F4F2A142D3C3400900B937968C018C0D7F556E58020EB9FCA4C';
wwv_flow_api.g_varchar2_table(31) := '126463000F38C6836A9000BDF3A4403E00780A2AC718AA0B642CA5F8205F145BCD62146D90A729887CF25DF6808C3999A04B9023A4F3F365CC820DF2947F5473424182CCC0ABA0022F1E1988994CC6003EB0E0D16089022F80BB88E89A73B3C947728DFD';
wwv_flow_api.g_varchar2_table(32) := '00FCC082470358B7E28E97434B2E1485E7E235E22D3326630C60CDE8C1717409A8BD6BEC78D58AC22D99F1D507008F8EC7585A4A4B76F0068785F01D0E397B313607E7E4E3A07928014E7504D9541AB3056771BAD76C9D6E93AC9F2E1B460C9ACE6E3474';
wwv_flow_api.g_varchar2_table(33) := '9DBDE8F6A3916E9F552F5DA7B7AFBD6BF4B6E997630CE0ECA1D0CDC4EC06F2CF8CEDF64E2F6E7892A5641BD6E7C741EEE8AF6F0C240DD229E0C52B705C3D0C73379DE59CFBE2FE71914AE431DB7DC6ED5513552F490BAF5B937DA4488EF1D218C0C96190';
wwv_flow_api.g_varchar2_table(34) := '5F292E7F1D671D7CB05303C1D956199F051667242C0F3078CFDF40195F11C5D9C307180B6853C126C00E5CD776D88EBDF5201496250F713D0B34149D4DAC35770012E99306EB1054FC0D51AB8AFE28927EB4F96216F018705CBA2D4EC3FAAA7D29BA7631';
wwv_flow_api.g_varchar2_table(35) := 'FE00E3D77D59566997F1938EF9640CE0246B0497D65629DE8901952114026503BC2DE1FAD7C2AADD2A41706D51C28BC06E465D5A08DA20C705E0AEB7268ACE0DA2602F8132059B146EB2E7EC73DA9CEB35406B1D743E053A3550D0964A5EB955E88A8E77';
wwv_flow_api.g_varchar2_table(36) := '05B91A905E5A4A498BA25CB80F7AA11584F5D4585C6F1DE03771C56B2B1E7F3816CFDF4E8CBF97FE38728C034C60FD6053149C1BC5D1A5DF160BE55B01EC0E84BA20D6B7DF151FAEBD28C7416D56AE97970558D5A628176F11B71DFE1D512A1CC6750BBF';
wwv_flow_api.g_varchar2_table(37) := 'C32D892BCD9F8A9F37FE5EDCB8F0557163ED11090C15065A20E9F4609DC49EE748B65D1097375E111F3756C5A7EA5F13476A9F034F2D94900600B61C09F0C78D97C4B5ADFF148E7D18F974D73AA9BEC8E3D2C2A3E2E8F2E328D0AF59627B822DC42F1A2F';
wwv_flow_api.g_varchar2_table(38) := '8B2B9BFF167A0247DCB2F435512DDF8CB1749057141BADF318FF2AFA22FB9C6E420665EBF17C190558B20BC1E3A58F18BE036B5C8616DF203C0F003B55B1D5FE381C056B8600C9339EC382218472611940A30D0028D865581CAC2DE840E88B329F2E9296';
wwv_flow_api.g_varchar2_table(39) := 'A4AC84E4623ABC5249094E8BCF01DD82B388766D49AF523C1202ACEB53098AA25EF90C94F027B23FE5AA69E54C04D3057F0500FC80582829D054992AE7EB0F1DBB8A0B2A861A5FB97008E33F0280DB927ECBBD1236D19C8597633C180558F1499747A163';
wwv_flow_api.g_varchar2_table(40) := '370620E90FB5DC0FDA0A0FF92EECF4A820C4541B0ACA07B83184BD826139410F094BCBB0A575B095AEAF8FD8EB457D7A94C882A990680FBF03E06E8182DD21B63B1744C15A466B4D97945A28BB4D544B47A5C2928EEE93F1021D0A9540E64986D11AE355';
wwv_flow_api.g_varchar2_table(41) := '7D4141E175E4F8516392C928C00A08084C9E10660C5C0E9E026014AC5C592CF8F450D126ACA7DAB20DF3CA62A7F39158DB7A27049333B19A3B29F0A253073CB030B8FA8ED784A7F8B90447F547175A10DBED8F702CE2435E143F723E97F101DC25FC26BD';
wwv_flow_api.g_varchar2_table(42) := '47B5748FD8EABC2BE92B003918D404788BA57B317D1C4A94A146A84CF205A6449989FA84F3680C96A7FA8CC62F6B4DE4CB18C0DA462828BEC0B1378599F2100A022248832D851E35565716A2DBF5EDFF168D9DD75002616199E2619E77907FE7913F84EB';
wwv_flow_api.g_varchar2_table(43) := '5E8655B511F794C48E7B597C8079DEF51BB23C901139E658A800C21E4959BD448596DB81423444C981B502101B7141ADFC69B1B65D47590BA0A8889816CE08BC56B9474E23B45E17F33153C921E03A609359A92F0C9863C650BBC796AA36A64B6D52B9C9';
wwv_flow_api.g_varchar2_table(44) := '4750C981EC424E0624CAB295859005FD2195EC44774940285C7EE4399760E96D1F5C47E5B03A7D8EC02041389438720830DDA8E221809B3E0A4BBE1DEDB68189120FC12E176F8775DF22695041DAEE9AA44D4B5599EA306BDFC6004E0E2C1B2635C7FA58';
wwv_flow_api.g_varchar2_table(45) := 'F678013F4D19393332A535FA41031F085A5A784C4DD3A29BE51A5A7E6CAE69ABF25C0B58D7E3F2C5916B5ED495F5541B153475D36520E87A9BA28DE50DE76D2A0303A36AE9182A7253422902D7B2B5D27D722A20839C4B773ABF401D398128A21103711F';
wwv_flow_api.g_varchar2_table(46) := 'BD670355EA6D9623C7988B260F9AFD1446923D6A3D5D60A5788FBC966BDDD0AA388F79FE1108976B60EA5C4C213A43FBC0C20BBB19F8609297AE97414D58A1AB1EAD1DAE99F3A672D1842A69C16CC6B9D981056FC90F5DB3E411D1740D7F47F2DA165CAF';
wwv_flow_api.g_varchar2_table(47) := '74D3785F2594A986BF12ABE7DBB6DBC03CFF3344D49F9174D400E5F71E5F11977BD433576C0C60B2DE9F7D46AF6DB158BE4D1CBBF18F62EEA91151230ADC964AE013B8505DB4D2A846098B911928EDAE90B8D6755981E7C9C42B2A1CD7A2BE68627D7AC4';
wwv_flow_api.g_varchar2_table(48) := 'FF3CAE8BC8F564345D4134BDD97E1BED105D17EFC6E7E6904000703F84D55F91F563FE93F467E7DC18C0B100D3C28C07CB75A4E364EFE3EA5ACAD208764C5197ED76CCAA1DE90E1ACAF38C4A74D35BEDB370B99761B977CAE553A95087321E9300737BB4';
wwv_flow_api.g_varchar2_table(49) := '5EBE5FAEE3D93F973ECDD65958B78A8C230DCDA0ADF8ED5BA08AC7FC3D863998CE2F2BA9DC7899A2972BF111A8CA86F0C6514A9CAAB2A864B093AEF65D1784868AC4A5D58762B3F53E08D28D230FA0D34D7373857BD835FC7DE7D83DAFA3EEFFE21A11F6';
wwv_flow_api.g_varchar2_table(50) := '6E8C46ECA53A8DF2277362CC82F71E06F7A2B7C536E62F9988A56E24CF95B0B916A5D0D57664AF107AEC21A4A149A55BF4D44F56402302C7889C6EFA06EF97B07B861D2F582777AB4A0EDC3294AE52BC296C05F7DCFA00EEF912CA8F45ECABC23407E9EB';
wwv_flow_api.g_varchar2_table(51) := '64C7933B37063005A985D9EB5D0344B645D1689F171F5C3B2D05C3808B826422A01E6E042C2000BBE386DF45B085AD4A0438B24C7E777FE97E9215BAF2C2EACCD362E6790F5FB211E7E245B97BB5DDFE0481531DBCA82DCD6AE9D388C4CBB064AE9FF137';
wwv_flow_api.g_varchar2_table(52) := '96B09CDA689D0BF94EF5984D3CE4647A076300770D414B35CC94971000AD92775C78CD8D0315E1527478060977994ACE36EAA41A771156177BD7C86884ACAC762A72AE82AF2B9873DFC37EF49D5004055EAD724C06522A5CB344CBBD26E76B46D583A758';
wwv_flow_api.g_varchar2_table(53) := '1154748259113B415C63AB78439793BB2C0E07EF29ABA6518023F634CF618FEA9283C2B0705789F56C81DB887297899685A508FEA88DDA4AEC6533450E54464BD9ED1437A4D88475B6BD87E1419611F5736BF276304720C83BDDF325CCD797C167797706';
wwv_flow_api.g_varchar2_table(54) := 'BA3A8AA422E9703A608ECF3A5D9B2F9483F990C8184532DD35AE1E11A85239B7C2352BED6550830F072A07CBCD85DE94CE4B5FF7B6C8CEE9DF8E0F232C2292BE883D6BDEF1A2B709E41DA802DC3315D3A57BDE391B12A6D8FA53DBAD48592FB74D31662B';
wwv_flow_api.g_varchar2_table(55) := 'F989E9F50B53B347B57BAE310B960AB96B5FE10064C57EAAA09CD8AE6450D8AFF59EED621926AA124CDC4DC25CDBF13F8115BF8779987BCEDCD9C27A1CEE1A7F6A4EECB42F639E3E8FBEE979F4932509327D4F15B73EFA60B076C7E13F404D32128E028A';
wwv_flow_api.g_varchar2_table(56) := '2463102CC7AE6EFE58B4FD8BB8567BE67D490E51600C60F619093E12244FA88FF88781F05F77628B645E5C4FD5CE6AD3DD028413B4410BD73AC567AA0DEF72293ED43664F8D77C7575F05FC43CFC2EF699BF20EFE3D2DB70C9442EB88C72BDAB986296C2';
wwv_flow_api.g_varchar2_table(57) := '3E485DD1214DBDC492C43476726C2C238F9EDCEA3C5C5D9655F41769738385372F1ADB6F09FC1D4514F1B1A624F7BAF6F047A3009359CEAEEA48E5E7361F9F43F261213CA23BC9B7665E1FC9B86ACB1BEF8CB8E9BE1CB6950FE1C50363AD4891704EE190';
wwv_flow_api.g_varchar2_table(58) := '36AD4DF5C58D145583DF7082717D0021375B4097418E5A93AB272B3865D85822D14DF3762397498C9EB1B30DE16FC1B2FF4F7248C01555B5EB461E83E87620C5090E4326C99B5C2DD82AFE40A12CE2314A5239D8868DCC27A3004B5182510A8E026BBB57';
wwv_flow_api.g_varchar2_table(59) := 'C50E5C9F8B1BFFAE5F4100B3861168784229A0A65208B51E6D75AE60ACBC398E477620BC0E6EFB110C9528289D7886BB3AB0AAED4E1DD6C5C782CAB8BE26FB663FA4ABEAABA3DA7B6E00C44F401F0F12804F3EAB451749D06C46F3B8E9D1D8791B00DF84';
wwv_flow_api.g_varchar2_table(60) := '7C750F9B5B93DB9DF7C10F832BF24DF7DD92B726A904D2D249CBE75FA825AD90373CC1B10385E5EE17F362DE711926F248A573B147409A7CAA54C943D7C877340AB01A16B7F0CA58336E898FD6FF19CC737F9702C646076FC141102AD1B698D88AF75BAB';
wwv_flow_api.g_varchar2_table(61) := '8850AFE05EEE3F4483A448BC600B6DB4556AA5508FF750893E6EFC8BF864834B2EBA53EE79B72070376CA3ED57B5E3139A57B77E847BCBAF863C85F4A54B2474F40275D1DC79134A7009D468ADDC9EDC025DDC6F9663619D05D1EA7C282E5DFD01EAE828';
wwv_flow_api.g_varchar2_table(62) := '9B81D8865C252885F431FE7F4A8C5F92EAF90A3993FC7B50661B8F36F1B749EAA1BE9EEA43671803988CEA444173D3BEED7DAC842DAF0172E8B274BDE4916B4F3E95D1723F421BDED45716482B5600276BF35CD943DBFB24D5076F2B9665FBDE16169468';
wwv_flow_api.g_varchar2_table(63) := '4DB40375AB8FE554C0247D5A2DDD7DABF3815402C29EE69B4A0AFF843A3F937594629316798D45DAF6F06409C6A2AD57CB4871AE7C81E691E327DF057811F5D8B02EC9778CB9C9472714774C8400D162C8B81E981A92B6DCB8AE3E536DB81E4EB661FD98';
wwv_flow_api.g_varchar2_table(64) := '82AEAB8FB4265D5F099A75FBF741104457949AA64F40E19AAD9AEE02C75E9AB4520B73B6563455B99B96DC10C158064BEC437F066DB33765630067CF1BD9EBDADDD91AB64D5C9FE2D93BB196DA22ED5F77903A6CDD5F9114EDBDCAB33830072EA9EB0931';
wwv_flow_api.g_varchar2_table(65) := 'ABA7A1F2687D0769F624600C60ED5C666F88D73747C600A6FD1ED8F0EC29933180079BFF664F00FB9D236300EF16E9EE7721CEF2F88C017C1064CD26CCC600E632E9C04DE707D9B40C7301BCBA7A268AAB60C1993F29CB3FE4EB8B02059A3495A48C4791';
wwv_flow_api.g_varchar2_table(66) := '442E804F9C382E15CEF37C3C8412A8BB6FA37071D0269280BAA9843D72C894995AC65185214F72ED6469EDB26DFC2298F8823BFC93B75D87E4630EAA2BDB1A8DD1C1DAC25AA40C692D1EFEB12F2DE3D1FA55F7B6466D0BED524DDDC0BFE058CE3B4BCB0B';
wwv_flow_api.g_varchar2_table(67) := 'C7D7AE6C026BBDBDAE626B3DBCE471E44EFB34A43486A13F6C7DD52D7B183565B78DF9C01E386E894186CEDAD5AD77AAB638CF9EB48CCDF63A2035A81BF6F9C116D27F9CF9D6371C477C7F69A9B2AC998EC868C94719A9133D76DD307D64F5645EB279DE';
wwv_flow_api.g_varchar2_table(68) := 'B69AAEA6C96B26CD73FA982E9395C3AF61DBEABE71D4A78DF59D75F4FDC7BFF6C0DFFC805493324E7635E8B916CFA0F57BEA251978F99D6F7E31F09CAFC35BF3B9143589F4B438C8484B20D40B1B61EA9AE5D8FFF8D8FD4FFF17EB24659B6E33D16B3EC4';
wwv_flow_api.g_varchar2_table(69) := '31D10EAF83CE4CC9F4FF0172BC5A423CD47D510000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72349679541797172)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/html.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000016BD494441547801ED9D69905CD575C7CFEBBD7B16EDFB2EB1088945486C021C6227D8C4A9723E244C52897192AAA4B2B952E514FE909014522555AE';
wwv_flow_api.g_varchar2_table(7) := '0201E5042239540A8B4560261F52E5AA7C2005242E1B433008630B348034DA17B48E66A69799EEF7F2FF9FD7AF97996E8DA6FB76F7EB513F987EAFEFBBEBF9DD73EEB9F7BE7E123170388E6319C8A6A5596CDBB62D800AB47D3B260AB1EE06112E0E8719';
wwv_flow_api.g_varchar2_table(8) := 'EF7CF2913B0239E76B6239B31D5BEC0045E6DBC3B11DDB8A0582E1B38968EFB37FF0CD870FBFFAEAABC1071FECB32D4BB43DBEADFA342A169A46DC49514BE1FEDB638FFCB693B5FFBDAB2B36CB8178007D527CDF056845C3625B812DCF3FFBF85FF6F5F5';
wwv_flow_api.g_varchar2_table(9) := '0D4293438E6CCBA1F63302725D80FBFBFBA9A3B9EF3DF5774B9C717B7B4F4F62D6F0C8E838C2104EC0949177C6659905AC74AF34ACB48378E1CC83D73C26E6EBC5293DBB318B71CBD258E8A07628E4A412DD5D0F64C7E5E5E7763EF57B7FFC17DF3A2484';
wwv_flow_api.g_varchar2_table(10) := 'FC2820CF004DAE0BB0F4F7BBA2B6AD35B6E55C3F3A9AE27742C79F07C23BF356E9F5C4EFDEBD8967C6E3E185BBDFCABF7BF7269E27C6F5EE7BE1026D75AC5C3637D2DD15BF736434F91234F9EBDFF8D36F0F8A00B2D3FE9009A3E6E3A38D1B55628E930D';
wwv_flow_api.g_varchar2_table(11) := 'A0B35BB0CBC88B1FEDF057A86D8043CD6832E524E2B1BB65CC22E43530D5D9EDDBB70579AF6601F920615D1ABC6FDF3E6DBC6D071C25DC86A2E0300C6BAF9093A9742E91486C4DA5527B5E78E6C9871EFAABBFF96CC3860D840CC7CB75247DC06C5A55A8';
wwv_flow_api.g_varchar2_table(12) := '4B8337E63538AC45A2A74FB280D3AA4B0B235B9C0A08B535994A0172FC2EC772F63CF7DDC7AE85E395DBBE7D7BDB6A725D1A5C4E8496B93CA46DBED10C033020B3C3DB30D7B9443C7E7B52522F41937FBF9D35B92E0D2E07D8B6EA4B97C1AB3CCF9489AB';
wwv_flow_api.g_varchar2_table(13) := 'C980AC9ABCCBD564CE1ADA6D4C3608B85DD51738273B52259063B7079DE02BCFFDCB8EF534D7ED06D920604F09CAF5DACFDF0A352E6A706975F390E178C5E29B43417979CFF7DA0FB241C0EDA7C1851A4FD6600F744193E3F1F8A65C2ED076900D02F664';
wwv_flow_api.g_varchar2_table(14) := 'D23EE72934D86B484193E3F1E8A66CCE7AE5C55D3B36B48BB9360818E22A48CC938DBFCF050D9EBA9A05C8580CB9C5B6AD1F3CBFF3F11BDB01B241C090D2342436B54C7D17A30472FC4671022FB70364B380DB4C836BE84279C89C27C700D92A81DCE7CB';
wwv_flow_api.g_varchar2_table(15) := '299459C0335B83BDFE50D064385EAAC92FEC7AE296BEBEFE5C7F5F5F20FFE08017B7E5678380DB986E752FBA1A20CA2D904AA5B358F1BAD1CEC92BBB773E716B5F7F7F6EC3867D969F201B04DC7E4E56815EE57970E176950BF6E820D6AEB35D89F87AB1';
wwv_flow_api.g_varchar2_table(16) := '658F4286266FC0268C5F201B048CF6B6B11257813855B00B39992C407EE1E9C73653931F454A3F403608B88D35782A8C97BFCF5D8A6032494D8EAD77ACE0CB2F3EB3E376A8B0CD64AD866C10305A73F569B0871E9061AE01195B8DD761F3780F21036ECB';
wwv_flow_api.g_varchar2_table(17) := '219B05EC35B7DDCED377B22AB530AFC949385EB16B1C2BF0D2733E80DC014C54B5395997819CCAC6E2D16B4380BC7BE79377B452930D026E63FB6C46833DE0AAC929986B42B66CE795DD4F3FBEB555900D026EBF65AC428DCD69F004C8E96C3C115B2381';
wwv_flow_api.g_varchar2_table(18) := 'C09EDDBB9E6A09648380BDB6B5CFB96073CC6AB0270075BC52492E86C4565BB6DD12C8060117C4E535D0F7E7066AB0D776173256BCE23185FCF2F3CFECB8B799E6DA20E0F69B0737A94BB298602AAD9057C1A1DBF3FDA777FC4AB3201B7CAA12CD6892C4';
wwv_flow_api.g_varchar2_table(19) := '3CF568A3B30B999A1C8FAD00EC1701F9EB7FF4CD877F947F888F9B143A6736DD26B3800B36CF743567447E45730DC8C93C643CAA4BC86C6043209B05DCD1E0A97A621E3256BCA8C999B1975E7AE6896F00F29B2EE36DC6219B053C55F33AF7290140B630';
wwv_flow_api.g_varchar2_table(20) := '2667C661AE97A753E9179FDFF9D44396F5AD371CE751DE370AD92CE07635D19C26F1F772CD3B585808FBC9E3F0AE97BA63F213806CBDCE2A3878DB80B759516F950C7AD1A8735365546FD34B9E11ACB2D031557FC54F4FB512C57895AE4AEA595E8E0B39';
wwv_flow_api.g_varchar2_table(21) := 'AD90970403F2FCEE7F7DEAD711DB215C422E4959F3A5914CDCD2D1B862FB6AAE506B127A3F11F5CE6E2DA6EAAF1C507914E355BA72F3D2CFC90B2A4C10C6AF19B33168B225367F0BF500E312323CEBBAF9D49D8156DCFB28B6CF0BF1FD1990B0F113E0CF';
wwv_flow_api.g_varchar2_table(22) := '4361A5710E04F04B43FCF1EC5D7BDF79F6AEBD7B539DBDF895D2222CA0E50483E9B1CC181EFF592801EBFB7B767D572173EA04E7AB2EA99A1D837D8FB3BC82846ADBD9602A399CC65465A4FC6EC9378AB89A75BADC3D6671B9FBDEBDFC39353A3C120C06';
wwv_flow_api.g_varchar2_table(23) := '1765C7B34FFEF33FFEFDA77FFD0FFF74A0BFEF4128617FAEA436D3BABCAA015352783B41343B960966C67218526DD7D9E29C854E97772E132949E789E865693CAF1794869526AE9096B7A9A6280F77C3B8C6BB410237A032CB71E780BE4521FFAA8CD29C';
wwv_flow_api.g_varchar2_table(24) := 'AEF4DA206036BA1D0FCB0A87C2610855C6C6B2902F84ADEF7FCAC398D42C2F207FD6133EBCB3C790011A562A132F207FE689F1F17A043D701D0A85643C97CB0277D60DACEFD32060D6B45D0FC709C18D9548300FD9568D9A0C6842FB26F0D2BB95C22624';
wwv_flow_api.g_varchar2_table(25) := 'AB164F470CC709220B2F17F15E9351298B2B0933EB645D49893E8C43A5E55F3010B4225066C817BB7BF8E9773EBC99E70259586B1EDE6B326A159B41C0C5AAD55A193FA40B42932391B03B26826CEB0EBE6EACFEC3206008A395F2A85F16851C68AEFD01';
wwv_flow_api.g_varchar2_table(26) := 'B950A59A2F0C02461D668612AB300939EA0B4DAE99AD26340B788668B027529A6B420E700AD37473ED8EC15E5D6A3D9B053C8334D81368EBC664DF8DC19E4866DEB9A0C97C9D5FD335B93E799AD5E01966A24B45AB9A1C86B96E33C80601C33ECF40135D';
wwv_flow_api.g_varchar2_table(27) := '09B2D546900D029E39D3A452A813AFD55C43931B05D9B411340818A298E11AECC1F62037C25C9B16A159C09E04AE8273714C0E34C8F1F2E334E92A005BDA441772A8418E57679A542AEB965D1735D9E414CADC48DC31D106BA8642E68A17F691CDCC93CD';
wwv_flow_api.g_varchar2_table(28) := '8DC41DC00600338B20E046228D32D7B557B203B876D94D4AE942F6D7624807F0244CF505F80D7207707D3C2BA6F613E40EE08A88EA0FF40BE40EE0FA5956CD8190753FD998775DB5A8AA373A80AB8AC6CC0D4E9D5CEFDAD4146A7AF5EA009E9EBC6A8AED';
wwv_flow_api.g_varchar2_table(29) := '6A32A750CD87DC015C13B2E9276A952677004F9F55CD295AA1C91DC035E3AA2D213539AA2B5ECD31D71DC0B571AA2B950BD9E4DA75F5EA740057974D43EFF06181EA53A8CE6E524385DFACCCAB43E66E5267C3BF591C1A5A4E75C89D0DFF860ABE999997';
wwv_flow_api.g_varchar2_table(30) := '4166C1BA1DDCD1E0663268785945C8A06BF0E1FA8E93D57074575E401132B19831D1067FE16FEE31932B17C9CC8BE9AD7865B36674CF206073AEFDCCC3368D16C13C07F0BE9078C80C6033B94CA3FE9DA85348400DA163C840E3A52E5314D7B2DBDED389';
wwv_flow_api.g_varchar2_table(31) := '6C2F6D83776685F8CAA1CB1E9E9352291EEF550A2FCDB05A7A846B5DA64A5F9A574DD796A159B04F01F3954678211884E99AFD729C7C79590E8E6685F7672BBC80049056212A10370F7611AF6330AD6357489FEF4A16D2B30EF4668B75402D0816612C5F';
wwv_flow_api.g_varchar2_table(32) := '3DDD8683AEA9779425F2A1065B323E9696EC781A152D47EBD6DC91702426C150145FF3F014AC05B02108DF964C7A5472D9B1624355EDDCAF04170A47917EF23CD30AA063A0CC2CCA671D0AF9177342BA8844A209FDF199822EB9E7C74BDF01C68BDEA4AB';
wwv_flow_api.g_varchar2_table(33) := '778EC4123D50124FFB8AA2A316A64787259D1A76B50CB75C308EA4929754B37A662F90DE390B24DEDD83A729628C2159001F4BA764747848462E9D4307C816349AB90700778C60334949F4CC91798B574A77EF6CC08C6B39E3E870C9E14B3274FE7319BE';
wwv_flow_api.g_varchar2_table(34) := '78463B4824D6054B50F35B06596CC30F83802B69DB74EB6F29840D5BEE93EB6FDC2C78E19BAB44804AD884CB69C4FE0F7F261FBEFD9A44E3DD0A86F0C6332959B87C9DACBEF62659B064B97475F74253C378209D5A2962C32C132AFF3E3F7954DEFFC96B';
wwv_flow_api.g_varchar2_table(35) := '827743224E44EFA7D139E25DB364FDA6BB65D9AA6BA477F65C748EA89A7B187735CBE3E3E332820E72EAE820DE31F83E609FCA77446631B9336AC62DFE3008B8DE06728C8398A011F144970AB808988AE9020EC20CC770DF067C6A5D767C0CA2B5E5E6BB';
wwv_flow_api.g_varchar2_table(36) := 'EE976B37DE2A3DB3E66827E0184B73ED1D18D5F19AC030CC3BCD735022B138B4F9023A4D0C9A3F248B975F23B7DCF94559B46CA5760CC7E658CBF46EBB38AE47A231D5EA858B97C9D255EBE4C3FFFB911CF9F4E71285B5C15B9E0B71BD32FD703608B8DE';
wwv_flow_api.g_varchar2_table(37) := 'E650902E640AD6CEE5300E021E859CD760759E108B611C6FA9B97CAFE4967B7F43AEDBB859C164A16559A40BE09D8F21C45127293F469315C7CDF131AC12218C1D240353BF74D5F572E7AFFEA6CC5DB0081D262B6399B4DEE37B23999407AD47363B2E36';
wwv_flow_api.g_varchar2_table(38) := 'F346BE8B96AE449AAFAA3338B8FF3D8941FBD929FC76F808304403698623713979E4800A6EE98A35D098396AAA29ECE1A10B72E2E841397DFC908E813908FCD67B1E90F537DDA69D602C0D30794D4BA79372F6F40919BD7451C1D0314B7475CB9CF90BF5';
wwv_flow_api.g_varchar2_table(39) := '859F74B2388E2F58B256B6DCF36599B760B16460E609340C278C96E1F489A372E9E279AD57372CC3BC858BD5028CE35E06E339CDF8A6BBBE887A9D9773A78EA8B9A6656187F4CBE12FC0904A0826F4E8815FCAA92303F2A5DFFA4308711E00B9DA360C58';
wwv_flow_api.g_varchar2_table(40) := 'EFFECF0F1502A73A2BD6DD84B17A0BE419805666003DA49AC64EF0F107EFC8999387110E68D02C8EDDF49EE72F59054D5D022D4DA1138531E6DE05C8CB00379D871BD18EF4CBF77E22873FFB05AC414659053156AF5C77A3DC7CFB1774186007A0A6CF99';
wwv_flow_api.g_varchar2_table(41) := 'B7506ED8B455DEFAEF63DA11594E25E7B055C07D07986694A693D3206FDEEA0987CE0E35319D1A95682C813177B38ED78443CDA5B93E7AF013F9E9EBFF2923F074C398CE50E00CE7ABD3D3A9111D334F1E1E80866664F18A6B65F9EA6B140887857024A2';
wwv_flow_api.g_varchar2_table(42) := '79EF7DFB4DD9BFF77FA191B3345FA8A43A711FFDEC0D401C973BEFFB2AC6636AF9B80E018B97AF9285CBD6C98943FBD503B7615926D6DD6B43B3CFBE5CAA249000DE3247C1961EAE171D140A70DEA215321FCE4E0E63350F3A504317CECA076FBFA1D398';
wwv_flow_api.g_varchar2_table(43) := '6E4C9538C5A1E65153E92D4731ADA1A7CC6915B56CD1F235EA6DD3B36647E01BED8E0E7E2A073F7A17A0E6C14BEFD2B474ECE8B1C7317D1ADCFFBE9CC010C24EC8FAB0FC44570F9CB3D5C8130B28F8F30B5CCAC59780297CD76199ECB4E4E0245188F317';
wwv_flow_api.g_varchar2_table(44) := '2F9728BC5A3A4D84430D3C716450CE9E1C94AE9EB9EA65D30BA743A682473CFD4E9D437A5A029A6A77712407902149635C253C3A78EC10EAA1635ECE3238DEB3A3F0DE494C93E87071C58B5E3FD37228A187CE3178E6029ECC839D68DA87EA6DF1A3989E';
wwv_flow_api.g_varchar2_table(45) := '6100460DEC9D335F054BB0D4268EC1E73F3F0178984EE581970BDA7D5B3FAD022184A1DD74BA9825D3B093D0711ABE784ED397165A960FB476F8D205D7D3C6D88FA47A4431EDE20A173B000833D762162DBC32ABC10AC5506BAAC887D31E6A0CE7A42A78';
wwv_flow_api.g_varchar2_table(46) := '028540A965E954523D5E56A37255DC50020D434369D6751AC5D8F89FD3322E51EA3A74A566301A1D3A3868EC5005F008A783476BA01DAC4AE995B26C749859C055A0D4DE880A191228B48DC275E1B8B9332685EB1EBC77F9432102CC94112B6693CF9DE9';
wwv_flow_api.g_varchar2_table(47) := '9901BFB2EC7CF97A573F2A266E6AA059C0DA6093F5AF90615E5B39B6D2ABE641D0DC24A75683BC7E9FAA16F48669DE19DF25C4F96F44C7518ED1150F6568637C8EE918EDFA096E1DB88CA9E3323A9F82AE50F58A793638D02C60E3959DAC06BA2E8C3194';
wwv_flow_api.g_varchar2_table(48) := '0E1141E8788B718F539C39F317B9C8A9E5045DD068B762EE7774069852CE61B930420E9A27604763588A9C3557F3ADDA14E4C9450F8EB95A7EBE83707818C34605FD8182D9AF9A49F36E18046CB6CBBAE3DB843CC1DBF55C1DB978EE739DA2780E15C7E5';
wwv_flow_api.g_varchar2_table(49) := 'A52BD74AEFDCC5921C1D828661A300C2560D0504E6C738EEF406FF840E56BA2E9E3FA39B10CC8353A5683C214B56AC435C78E5E844DE4604BB0057BE5C8F3D284B57ACD5F19B532475F0A0BD5A1F9C5906C8378FE0142519046CBA5193F3A3661014FFCE';
wwv_flow_api.g_varchar2_table(50) := '9E3C82DDA0117D7D11DB48F33817CB8DB7DCF56BBAD4387CE134C2DCB56C9A73C2E042C7C8D059C466DE8E9C3A3EA89E33A1A8590698956BAF9335376C11A66727700F076BD623323A7446EF2DC346839A77C4E783092358613B750CCBABE8046A127C04';
wwv_flow_api.g_varchar2_table(51) := 'D8772B5984E7CD3F09460546294399F93D931CE652979C3F731CEBD283BAAD6859FC07AD38260764EDF51BD55C0F7CF82EA64DC7D46C52A3B8E0D13D6B1E1637D6CA5C98F2819FBF2DC7073FC6BAF6666C31DE80CEC0CD842C56C6BAE5D6AD5FD2F1FCC8';
wwv_flow_api.g_varchar2_table(52) := 'A7BF00D8512D9BFBD3D7DDBC5536DEBA5557D1B81EED7ACDB61C3BFC99AE4547E33DD07C6F5CCFF78D169F7C07780C6BC76BD66F96156BD7EB5847CD23749EB99870F7577E578E1D1C9003FBDE51480BB1F7CB0D840CC6539B2B52D0A8D5D76C90055808';
wwv_flow_api.g_varchar2_table(53) := 'A109E6DC960A1B0C872401785C3BE6C6FEE0C087923E75186BD66FEB2E522FC65E6E36D012CC4239B7DD73BFACB9EE2698FB11942FBAE2C58EC1C50CC2659D38EE73D163FFDEB7A0C97CC530E6C530ED9AA0C560BDE27D041852C4FF59383F8B96AFC6F6';
wwv_flow_api.g_varchar2_table(54) := 'DF2680C8E8D8A880012F814D7C8667E0D01CFCF85DEC161D15AE1BDFFE85AFE80600E7A65CADA2F9ECC2D31CDD3DB3D04E9A63648C339D2C8E99C9E4888EA7D4CA53473F91BD3F7D536EBBF77EAC80CD82C6670030A3E32F77B34A0FE6ED6D6AD0E33E73';
wwv_flow_api.g_varchar2_table(55) := 'FAB8BCF7E3D7D4EC4713BDBAAAE527B8ACBB59C09387CD52F94CE39AB0E9D8842458E0830B84952E4244B0E17078E0035D46BCF98EFB64FEA2A53AD5A1B6F34FC45DA7D6829916171C27B94F4CB34DF09168179ECE785735973B45F3B07C6905229A27B5';
wwv_flow_api.g_varchar2_table(56) := 'B9F4E06A17BD67861F3E308075EFD7B16375486230CD7E7D74C72C604AB0E60302E7BFB40E13CB4769D4C355486E86EA6001084D700A1A48D04446C847B0AD77F1DC6959BB7E13BCE035D0E6B90A829AEF1D5C42E43359673F3F29270E1F80E91DD6BC90';
wwv_flow_api.g_varchar2_table(57) := '052027E4D0C05EB978F6A4ACBD61B32C8105611EDC31F20E6AFFE8C8B06E681C1BFC049B0E1FC0691B76E1569B377B895B78360B984A51D7E140A87198DFF7E5F8A101E444B3EA195855608459EAF810AC7ABE80480D1A193A271FBCF59A7C0233DB3B67';
wwv_flow_api.g_varchar2_table(58) := '217683F0C01CC64B6FFCE612646AE41236F0CFAA474C4DA6B926788E9DCCE3D28533B2F7C7FF259FF4CEC5746B51FEB9AE889A76CE9B47B1063D74FEB4A4E1E8D169E30E933A8275B5B9B189CD023650576A26FEC1667DF2D1453B3953C2D1F9266F417B';
wwv_flow_api.g_varchar2_table(59) := '30798226BB4F38727C3E3DF2A90B9FEA492566C7434FE126052D00D37BA65EB5BC240FCE7F53A397D061F024079EF5F2EA400B12B0DCB47C068BE91A09B77C7040356A3CCC022E5AC41AABE326E32600172A5C320CF328B9D7DE9C95DF0A00B0D900A9AB';
wwv_flow_api.g_varchar2_table(60) := '0570044B96B4F83ACEBA51740456DE5CE1E21662A9B9712BCE7194E36C1026DB896A06EC177A6847D0682E583EDEEB95EDC630FB39F9A9EDDAF2370BB85466B5D54753A9F05580D3CC0434F04FB62B6837A50B8E94F85F017AC9D83CB10496ED54C8C3ED';
wwv_flow_api.g_varchar2_table(61) := '54884DE29A3E9FF7C40C7CF6DD2C603FB4B90C5E851E5776BF0A8DB23813F228BB5725BD8F820D2E55A2551364E1A3765EB555310BD80F1A7CD5A2ACDC70B3802B97D1096DA1043A805B28FC6614DD01DC0C294FBB0C73CE8C59C0E6EA356D91CC98042A';
wwv_flow_api.g_varchar2_table(62) := '4373CE4C5D80F7EDDBA73571575D2C2E28758E7A25A0322CBEA3C39371ADD9D60578E3C68DDADF02011BD5722CAE01748E3A259097A12B53114FC6B5E65AD742C786BC06DB76C0C1FC1F4B40AC9DFB516B85AEF2745848E39A1B74C58645C4E1C9B856B9';
wwv_flow_api.g_varchar2_table(63) := 'D4A5C1F2E0835A6E206C1D04E081AEAE38BF73859ECFAD74FEA62503576E9421654999AA70F332D6EB1A3EEA1A35D1DBB006EFF6B45D3BFEF6772CC77AB62B119D4D1DD6C5F91A2A74B526A1E672157434991EC2B6F89FFCF9C3DFF90FCAA254C6B5C8A6';
wwv_flow_api.g_varchar2_table(64) := '2EC0132BB0F3C947EE08E49CAFC1C2CCC6868D8D8D99CE710512D0670BF1E346B8311781F4877FF6EDEFBC3351B657904DE3A2B097352EF7AB33675332FD7F5B1C411543A1D9FF0000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72350111031797174)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/ico.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001745494441547801ED5DDB6F5CC7799FB367AFDC0B49DD255FE49B64595412BBBE046A1AC78EDBC67D318A22D24380BCF5A57D6A10F4214001B30F89';
wwv_flow_api.g_varchar2_table(7) := 'A2A8CD3FD0A028025B72C5162890A64511384ED5D88D0B3996A528B663EB2ED9A2648AE472977B3DE7F4F79BD9E11E2E9712B967C83D87E210BB73CE5CBE99F97EF37DF3CD37670F8530103C4F5806C8F495C4A8371A5B0BE3E8646260603CCFB3103C12';
wwv_flow_api.g_varchar2_table(8) := '7EEBC36F3DE339D64B4819C2AD1B9878676F4DDE5BC245DFD3B695FC6C3099FB87BD0FFDCD25CF3B6E0B71D0B52C21C763B2B97ED18A0769D80FEE89B3DFFEBAE78A1F1586D283E4CE02701724B45AEE64A5BF9C26D4AD4C671AC975D6D569FEB22C3377';
wwv_flow_api.g_varchar2_table(9) := '8F0B2F299AF5C493EF5E38F4179675F0E21B6F8CC63D6FD4592B20FB5942762C2B78DE01DBB2C69C13BFFDABEDB665FF6C68C3C0C8D444B9E159226681DBE4A3E6E7E20DE9526C5A5D7B88557D1DB7B1D3A575C9CE9CC5EBB66BAA2BA81DCF7313F17465';
wwv_flow_api.g_varchar2_table(10) := '30BB21DFA83BFFDB14EE379E78F03B12E4E79E5B1B20C796856847E1B1319510B7620F62FD7AB43855110A5C01BA1E40F6E6C54C5BF8516555BAAED719B7EBCDA7B99CBABA2C271FAF39F73C68304F341ACDD2D070667FDCB25EFDE0E291079F7F7EB4F9';
wwv_flow_api.g_varchar2_table(11) := '8B5F8CDA6B614DE6407B0E070E8C501884EB5A3161C9B5989207C645E1D3EAAAB06C2A8CE9A98A97CFA77FBFE1B96B0AE440008F8D9D959AD7B663105C22DCF35CE95F4557360D0BDAB38AC5AA5328A4F713E4331FFDE0614AB210C7655EFF3A18ACE540';
wwv_flow_api.g_varchar2_table(12) := '006B096617B0F629533A587F56A536546F3B2865EDC594D56015672A4EBE90DA2F6CF7D8BBE77EB00B869723C45864410E04709B4B5CD0F8178DD0A969F45A0B218E515D4B491ECC3C1D8FB9AF9EBD72E89128836C0C60BF504403E6762F01B8EC7E2BA6';
wwv_flow_api.g_varchar2_table(13) := '11664D1729C9E9A7DDA675743EC89199C77280C6008E8AF4B6616D5F69096EA7484B5B4A320C2F82FCDA7BE70F3FAA24395A6BB23180B9FF8C6AD012DCD17F29C9C5992A25F9C998E5BD76FAC2F7F6444D5D1B03383A2B300DC2F9A18B04EB020A6458D7';
wwv_flow_api.g_varchar2_table(14) := '00F9714BD8C7A206B231803B99A63914C678DE72826DD22212ACBB2E419E21C8F9D4E331807CE6E2E1C7A222C9C6005E28179A3F218F97C60196B2664A5527079085E7FDF36F2F1FD94790C742BE855ADAF09684D13CB958528DBE15EA4DDDA82D945A93';
wwv_flow_api.g_varchar2_table(15) := '3FE7B8EEB1F73EFEEEBE832107D920C07D836BF90DF73E17DB6B723EB5CF8AC5DA208F1D0CA533C418C0BDF36CF9F804AED19B04EB66DB20173212E433E78F7CFEE0C131670C208F8E8E1AE3A96E30481CAACE0419C8B2EA76CCC6DB58D18B9125C8B152';
wwv_flow_api.g_varchar2_table(16) := 'A9DA2C0C66F609CB79EDD4C5434F10E4BD7BCF5A6102D918C0C18462313EAE42FA9DADE8C53A41FF973D335D6D620BF598ED89A367430872A0273AFC23EF100A7F56F8AE391B7587834D716EFFED22408624EF29162B04F91B230F7CE75DCF1B01E551AA';
wwv_flow_api.g_varchar2_table(17) := '6C755ED5272E041B9EAFD391F2646970D9FF20EC576A0B8FA429492E14327B5CCF3AF69B73879EB6AC51F7E59701719FD7646300B745C2877A482FB1E6B643100EB427CA9C24435D3F8A83F1A3610139C8F0DA4C8AD815246E5EE8C1C89A57BF75232599';
wwv_flow_api.g_varchar2_table(18) := 'EA3A3F987E04C715AF860164630077F0AC1B03429B760757E572FA3D0772369FDE45904F9D3FFC4C3FD5B5318097C385B0953524C17A586A4D2E569B04194F331D3B7DF17BFBFB05B2318023656469285AB14109D694E740CEE5D20FE161D2A3A72F1EE9';
wwv_flow_api.g_varchar2_table(19) := '0BC8C6005EA3C7851AB05EE23990F1D0C003C273FA02B23180FD86692FDC58CD3AF3EC85DE1D1D4BE9B204991E2F826CB9CD63672F7DFF0FA8AE5999BF875A0A9120650C361025887D2C33C8011F55FFA5F47811E45C21B313CF901F3D7DFEFBCF4A07C8';
wwv_flow_api.g_varchar2_table(20) := 'DFE2907585413638BC7972E11F60F8AE577F2E2AB7260C2F9C27DF07B17E650E64F1321EC95E3949360870848EFCFB3317E7D6E45C2E09903D09321231DD560E6463009367FDE15BF814C46D7AA4409EA935B3B9F47D780AFBD5DF5C3CFCBC0279744524';
wwv_flow_api.g_varchar2_table(21) := 'D918C01192DFDBF07F55B224C8E552AD812DD4BDE0DB2B38A0F8AADAAA9997646300F3879E510D861D1D4B61039865C54B33D506247987EB8957DE3B77F885959064630047175EB9B4403D2A5C18C90FBE9836F761BAFFBEF35AE7EBD89FDF4A434BB219';
wwv_flow_api.g_varchar2_table(22) := 'F9C51FDA0A11C7D39A94E4EDB6EDFDF8CCF9EFFE112599DBA8E3C70FE06D03C183318023E9C90208AD40B50900D50F24C979DECFFB744BF397D1F93AEE9287164852D245C4C076133333706B4292F14BD657CE5E38F42233F8748889A3466300A3AFEC57';
wwv_flow_api.g_varchar2_table(23) := '34820696062C66261E9EC37B3970A86BC7DC9815C32FD757F113435B31DB9E2DD5EAF97C660B3AF34F1F5CF9A104997B65487B20C61A7BA2231AC8B67A0996514D1254C76BDA2588902BBC52BFC7502CCD94ECB8BDB5516FFEF0F5937FFDD10B4F1D3937';
wwv_flow_api.g_varchar2_table(24) := '3676004238869FB0F6168C011C689AF5D6F740B5547FB1E079CD54D5A9D9B365C773E16622E8146BA59174EC6F4AA7E99879FA5AC7FEF2FE6B9DAF639DD7BAF744020AC58106790CB30F16B638A77E83DD7A57862EBE8CD818C0CB68331C45DB526CA5D2';
wwv_flow_api.g_varchar2_table(25) := '8984854D696516AF618149AB406637BB4D5B9DA6637F397F5AB761EA7C1DEB32EA9E5A2599880BBC10A6299A1EDE2E103C1803388A461685954C05A85E224973C416B3E5A6F008321F8CA5603190FF5DAE99A4A061A1E5850575152128118FD6334C2F45';
wwv_flow_api.g_varchar2_table(26) := '4FBF266379D4DBA58D1959513A2E6C0F1F9C548CE5FEC58A276D2B334061B62C309A2698FA20AFDB35E8B4D39779BDA06EAB0D39637CB3C6FF9A0C7FBF977A6D0C60CEC8C8070C22918A09802CF8CE8EB9CDF16A0FCC20338D01DCD661ABCD0DC3ED8505';
wwv_flow_api.g_varchar2_table(27) := '6443C33208B04FAF18EA5CDFC8F41B6483AC3408F09A916135AF007292EA3ADB67751D70961B039893CEE0C40B382C33D56961D3BA8E32C8C6005E63F2DB9E2194E408836C0C6058F96DA6ACB12BE98000C803525DE387FE4C88483006F0DA855721A9D5';
wwv_flow_api.g_varchar2_table(28) := 'F540368E2D547440360670143D59CB15C20520C3E3B522C120596300AF3D13AB3B7404392ED53524D95E214936A80E0D02DC9D216B321520D3BA96EA7AA54036C43863001B9C748686B6B2645645920D0CC118C006FA123D1254D70948F2C00AAAEB805C';
wwv_flow_api.g_varchar2_table(29) := '3106F0DD606475E5B56F4DC6233FA1DB42190338AAC7855D415B6E22D7644872065BA8B0816C0CE0E5F264AD95975BA81082BC0EB0C1991646908D010C2DB51EC081B0816C0CE0BB6D9B74BBD91C26908D017CBB01DF8D791A643A43FA6978AD03BC82B3';
wwv_flow_api.g_varchar2_table(30) := '8F20739FDC4FEB7A1DE0150498A4B524F3A181254BB24183661DE01506B80DB2259F0C5912C8060D9A75805701603FC87C684082BC52478D1DE33106F05DEBAAEC60E8ED6E5DBC3C299EB0E49321761C6ECD5500D918C077B5ABF276A8FAF2F44F655613';
wwv_flow_api.g_varchar2_table(31) := '646300FBC6B17E79070E5070570BE47580EF00C64A64D3869A0732B6527C906FCEB60AA3156DB04F2BC1D3D0D15C0032D664822E419E433A78B78D49B0C13E051F55442848906978C595E1C5988698C9600CE07509EE0D9639C30BE066B185E2DA6CD2BA';
wwv_flow_api.g_varchar2_table(32) := '36F603F07509EE0D605D8B1E2F9B921C4F08A7E90AA76646648C01AC3BBA1EF7CE01E5BB86C72B9710CDA4195DBD0E70EF78AC484D29C936DEE09069BDC321602BC6D6E080FD58AFDEE200973A826C2A845882EF34CA6EABBEAEB3DCBC4E76924E278DDB';
wwv_flow_api.g_varchar2_table(33) := 'D1EEAC1FECBEB3E520D48C01AC871FA433FEBA9660D7165330F47CF3DD60BA550588AA032B742E5D51546E54A6735DBBD33BC5628056B5ABE868DA8AEDAA5DD2310983EAE74A7C1B03D8F4701DBC78CEF56A2D666B20D90AAF63F897440378438E7E5F27';
wwv_flow_api.g_varchar2_table(34) := '8701D67BB3506F551F9F14382A01305B29D44BF9F2F5A5A2899719CA3649871341F996F8ADDBC549502C8BBB04F2F81A2B3F7D4D2B5CB13180CD0D4B312D69EF00333360A15F5A5A0CF55CD1706F018C3A981D47AC804DD89B4532BE4B24EC0280CC200F';
wwv_flow_api.g_varchar2_table(35) := '2E4000E1B815D170A645DDB981B255A4EB89C15E93661C13A381778F4D0ADBCA8A74E221D0D928E2124CE48906EACF887AF326685C4359177D2BA01E259D1AC1F4F4064943216400D3275B073849B1A5F082C8E35F0EB96E1D43D50C8434416A1DB72A3E';
wwv_flow_api.g_varchar2_table(36) := '9DFE0F51AABD0FE6D74422362C8606BE28CB27E3C3607EC20722A6085E1AE77A8EA836C6C578F167A2D2B8D29264052E27085B18CA7C490C66464426B915E00EA00C2602DE8007CF83A4D1704AA25CBB22A666DF15E5FAFBC887345B646178410E11C064';
wwv_flow_api.g_varchar2_table(37) := '36E50931DC3B497B1092B41100D790EA07382E253266A5114F895CEA09B17DF045914BEF44294A1B249E66A8AE82DA312F298148D8593159DE2466EB1F233FCD1CD02F89B83D2CB6E6BF2686B27B25B0C80009AA68D527BCE617E9296886BC18486E1385';
wwv_flow_api.g_varchar2_table(38) := 'CC23E2E6CCDB62A2FC73D99665714B134E904304B00F1172986B2024CFF1014C86E35FC5219D125503309B01EE9F4886B39C54BF00032FF39412CB729478FDEE49D253461257D518D6EC32686C10F70CFD1934C01E09A86A0F5EA5182685EC0741A66671';
wwv_flow_api.g_varchar2_table(39) := '501EEB3B68A7A0BE770C7D15BFF44F01E89FCA7C6598B52684AC178EAF10014C86D0A0A14AB4C4ADF229D17466A5DAB56369094C0C125AAE5D1533D58F45AD795D0C67F64BC92528048FAABDE996C5ADCA8790D24FE444605A325E10D9D4FD006618F401';
wwv_flow_api.g_varchar2_table(40) := '382597EB37C0DF5A78510C671FC3446AB468401A81EC6C7D1C2A9D6B362612D6DB81D47668953CEE1B5283B04F5BF3FB45A339292667FF1B136203FA7F270B7DF5413706F09C3A0B3406B5C692C444F9BF00E20D00731F0C9F012C830010EFC628D52E8B';
wwv_flow_api.g_varchar2_table(41) := '4FA67F0CA66F46DE4312308215839A643C5E7C537C56FA7750E0D014C3A9BAE3F626914D3E02236902C0A650B68C09F265803B02350DC9E60481D47249B839F30E26D82F31C1A64143F5299D78406C835D90C37FA9235D4E2A1BEBF4A6DC17B11E7F0423';
wwv_flow_api.g_varchar2_table(42) := '6C42AEC9425AD79DDA0855FA14D486CF40E36A2B61801018CA4010D4BE96775AF5290987B716F9493098655AB9522D3744A57E09CCE7BABA19936013CA6C44D92C247B524C557E8549330E6A2EF206A1963F8F382DA592C61255FA67A577C4F5E9E3B098';
wwv_flow_api.g_varchar2_table(43) := 'C7D90B7CA89E5D51AAFE5A5C9BFC37D01F07904A2E68BC65925B4421FD05D0E0D68A213CE0B237C600263193816A94EF705E18904306634DA4C4127A4E2E4A202DDF4DF967C1F43D90A84F915F41AE2BA5DBB6F2003B2F4B73AF9C4EEC84C1B41D12ABA4';
wwv_flow_api.g_varchar2_table(44) := '9C3467EBD7C544E904CAC0A8B23931608DE343830E2F621795E639B974703D66DFF4B23090A496C9E1BE21E9E32B34A11B0743D139AAFCEE6A9FFB62AEA13548D3755C6B66E3A5FCF81BCAEC163B377C536CCABE28A5D4718B308E4AC8A16382C355DA20';
wwv_flow_api.g_varchar2_table(45) := '9DD8867CEEB30130D6624A75B976092A7C1C13A100B068BD137C5AD3048EB53328F331CA140130F7D28A562A3E040B1B16BFDC63B7DB9095FAFCA5748D814E68256A809424D15DD1A954A9BAB1952A564F8BA1FA5EACC53BB05E56010AC18AC97BAACE6A';
wwv_flow_api.g_varchar2_table(46) := 'E349315DF900FBD65F433563EF1BCB4969A73A4E626B4429E4FA4BE9E5DACB355F6EB3E6D4ACBF171821406D626B566F16A525ADC71CC7F64B4E0A71157D0F97CC18EB8D9F15A6406ED3994F9D20D055596B5E85C3838E8B9B6030DC907070508A1DE91C';
wwv_flow_api.g_varchar2_table(47) := '1172CFBA6DF02BE2814DDF141BB37F48452E259F1344BA1CE51240E0D4B6AAE9AA75B4ED9AD43D20944CC52335906C6581B7F3A4652EF7C2D42EE10AC600363D2C2D1D8AEEFC3BAEAB0CF424CDC0F8B93C711C52FABEB26CB966C21AD64053AA33892DE2';
wwv_flow_api.g_varchar2_table(48) := '9EE1AF614BF412208262C57AADD7F74ECA9230CBE88B053128CF65EA0BC6FA7A4185BE26444C456B5EA913234A140D277AA62EDFBA843DF3E358833F07157DAF48C469505162E9A0A8613224C4E6FC53A286BDEDCDD24FA514AA47550179CB218217FACB';
wwv_flow_api.g_varchar2_table(49) := '0638399414B7DB232DFE715F6DC76871338FD38552CD7FE641BF787B5DD635FB1D1B0378BE120D3EACF9F2B090BA622D2C59184136D6564AE554E54DACCB27A19A778BE181A7A4778A0E09E58B6EC0D24D61DFFB053826FE07EBE82D74129A006B39553E';
wwv_flow_api.g_varchar2_table(50) := '557C2ABE1920F98D24F6822DE9DE707B45830A4618EAE849D0848F9A6E536EDDDA65711982105A154DE669062E649A025C1E0F0260B5A58233037B5E6E69CAB5B3E2EAE43F8AF1E913C2712A804C9D1E1114FAB8E9F4A8343E816437649E7469A24C2E75';
wwv_flow_api.g_varchar2_table(51) := '3FC0DB04692C830E8F15157B783CC836B8D7A5B384563327142707FB56C36469B8CA81C236D4A40801BA732308475F3A7A4185B85820136370416E057F9B92B96A4B43D62601D236F03E2F6E947E2266A192D5898FA2C5B597AAB8523F0F754D50A8C400';
wwv_flow_api.g_varchar2_table(52) := '0BC01E8035BE31FB2C209AC53EFA1652550F6858D59D4FB0963F2C36E67E0F75B0AD82EAA7EB94275BA5DA79D4C73220FF17CEE2BD5E6C342B996E4C459B1B9696CE3224898E0A0695C62B32B6E9DE8084C1A991FD0A986DC1B5F80600B826412258947C';
wwv_flow_api.g_varchar2_table(53) := '5ABAD9E43E1C2566514B1965BA3EA5AC0E47080D339E0ECD01062B7C53FE6914832F7CF62DE97EE412C0B3E541F8BDB7E49F9347899C0C2CC3E3C499EA357CDE538E0E5F3B6C2B0CC118C06D08820C4B79A4AC982D36E7FE142EC0DD60229CFF30828002';
wwv_flow_api.g_varchar2_table(54) := '40736048ED12F70EFD25D6D1FF83AACD41A24600D20E185A9F4222C7013EFF0521A57B18A74CBB452AB101F5E8E4202436F6C6132DBF710E347E05B5BC530C0EEC96FB6817070E5CB3B714F68B7CE661D08314A3EDB89D91C026B1F6125CA6F161845A73';
wwv_flow_api.g_varchar2_table(55) := '0A061B7CD6EE34EE87D182F28AC9C642F2650CE0E0E3A10EA0D1A4A46D78600400ED92274A12201A43002A8B539D7462100EFE73523D92D9746A0CE043E6731230D83478206152DA60F2D288E2931DB766DF413C238DA526D4F0A7D3FF2941CDA5EF477A';
wwv_flow_api.g_varchar2_table(56) := '5D59C3A897C5A4C926EF91B4F8C57EC9FD35FA11B707708A5414D78B6F407A4FA1FE204A840F5CF63B4400B33BAD20F53D152D9EBD924F6728FDC0FF45A65C84EA9ED7F2140992C76941BF715C5AB254E5705D026C1B69F8F7B1B09A67C48DE22FE1D93A';
wwv_flow_api.g_varchar2_table(57) := '893A590006D50BEBBBD2B820AE4CFE2B4E8AFE589E2BD37DC949A2A55E7749CA3F2609A12ED7AEE1D4EA0468BD2D69A832ECB4193DD66E33F85588006E812699E4019049791EEB602DD5D6B4DA87C6A1122B00A08EA7334E4A00538961B9D65A980C0C9A';
wwv_flow_api.g_varchar2_table(58) := 'CD94DE5AB3240F11A6664FC1183A833C9C40490F969C1290BE3C54F16558DDC744A1FA14D6DA3DD010388982FB51B74B9A94FE59F469A67A016BF749D0BD22EBAAD6142D960B5B0811C0648D7A0283EAF0C6CCEB38BA4B415E6834A9A06444ED5B9B3C44';
wwv_flow_api.g_varchar2_table(59) := 'C0DA373BF93B6C7D3603E00D6078567AB1242580CB63C3BAF319D4A93AB857BE686E7DFC80C0ED0990F9B4C6ADF2EB52C253F1EDB0C4492F2D41E624930FEDE1218306E8494B5C3E74275BC297EE21EFC3158C012CB5AA91B12966D59D9B72CDF54B916E';
wwv_flow_api.g_varchar2_table(60) := '8369EA1158A85A30BFDAB82AAAE2125AF7AB493D1DF8C80EBD4F5C2799E6075777989632D42FCA71BB338B037CB5A66AE05AB4A0EE63AD272D55BEBF3D4D2B5CB13180352B4C0D8F5B1320731B72346AB826A7A1A6F9001D99CDA0635EB33E3F4C23B00C';
wwv_flow_api.g_varchar2_table(61) := '8BD1243D3E6FCD76E9B2649D6EB448471B548BD14291900463006BA780B9716940EE44915B203FA3F5B51F205EEBF4C5E8319FE5FCF4741D4D6B297416A3DF9F746300FB55E9EA0E4583A05B25089DA1B34C67BEFFDE5FB693963FCF5F27BCD7C67CD17A';
wwv_flow_api.g_varchar2_table(62) := '8E8777A87767CF8C01CCB91DBDF9BDF641370670A7325BFBAC8BC6088D013CDFE28CC6E0EF865E1A03B87F46D6DD0053EF63340630B749EB6ABA7720744DD33C0C04F0D8D8D939BB0A128C5F14AD87A01C200FFDA2E2E7712FB403017CE0C0889C708EE3';
wwv_flow_api.g_varchar2_table(63) := 'E29C07673DA6A75F2F238A781DFD301F79CAA1681EF73AAC408E0E3DBB70BCE6D9F8E3538AF8A324AF41A8956CF5C6E8A5D505D3240F292D0EFED896E6716FED063C0F3E7040353B1013E76B96F8B0309419999A28BB44581B5DECA51E9E3FEEB5C38BD5';
wwv_flow_api.g_varchar2_table(64) := 'EB6C67B1723A7DB9E5553D8EA0D7D0BD6EBB1FF0ABE3180D3CB42727667F479EB225CD63B3AD2E911AA61B1E8942B710DEFCE0DB5F87DCFE283F98E6B1CD7CA787469619DD821E7B7BB4F36705EBF8F3FC3482D6D574354D391ADCE83E77C62CE74FD3F5';
wwv_flow_api.g_varchar2_table(65) := '182FB7AE6E1BB1BE2C4E57A741FFCFBFB4E7EFFF4592F4F1D8DFD452AF357B965A7E41393FC86F7DF8AD673CC77E09ABF1100AAA4564418DF5844E0EB4E6450C66EA145E29FC932F8FFCDDDB2CE3E76D679D55BDC7D21B78A2AC6A8723D098299EFE3F7A';
wwv_flow_api.g_varchar2_table(66) := 'B2C95F9ED1F6280000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72350470390797176)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/iso.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001634494441547801ED5D598C1CD775BDAFAA7A7A162E23EEC39D322951226992A14486422C281412DB80A30490C84450FC11241F4910079029290112';
wwv_flow_api.g_varchar2_table(7) := '4093AF18081C20090C27503EB2988B666809919D188A0344B2E138326C5A8E4451A24851B2499A147772969EE9EA7A39E75555774F4FCFD6FDA6BB7A580FACA9E5AD75CF3DF7DD77ABBA286221692DCA42334D6D42F7F63A5A5AFF3E2A85583730045729';
wwv_flow_api.g_varchar2_table(8) := '816C4486BEFAB9DD4A0A8F69A5BA25D081E354769794730C4C6B8C306897B6F95764D1DA173A1EFFF247BA6FBF2BFBFB83F87E9232DA7AC65117C063C0FDFBCF3EE1887A21DB91E93603AAABE57A6E69BA7531409D17F1168B9F59F16AC175FEB0FDF12F';
wwv_flow_api.g_varchar2_table(9) := '7D00267BF27C6F61AE805C170CD47875A0BFA0FFE1D33D23DAFB76765E664BEEF608A4A612CBDD12FC8030C8074EFB92E1B6C5EBE6FB79FF0DCF777F4B3DF9A50FF57F03E447E606C87501D1DF1F8A6B3870EE86C1BB373F086C4370D96EC237AD30E37A';
wwv_flow_api.g_varchar2_table(10) := 'BC033F5F18F0E677ECF13DFF90EE7B6683FAE55E5F5EEB75E7826F5117C0FBB76C3173AF0A8CB0400993B86B812D1EAEB8B0D5CA1F18D65E67FB43BE5287725F7FFA6E03F25FB43EC87501DC7FE284C1543B8A40C3B70A116EA5BF5A020ED7819BA8FCA1';
wwv_flow_api.g_varchar2_table(11) := '5CC1EBCAEE7503EF70EED8B39B542F98DCDFE7B43293EB0238667004A841B995C00DC70A1128A51D074B01A8A83F380290DBF780D6870CC8070E14A485995C17C09560B62081C35B00B25CE8C102511E0079B8E075661F24C8BAEF4F37B63293AD025C09';
wwv_flow_api.g_varchar2_table(12) := '78AB9C63211F856A608C8D7318311920FB4EE1B0A6B92693FBF7B79CB94E0106A23A62709942464C86B9EEC83E98D7FAC5916307377349D86A20A70003D51283CB200E977970BC460A99AEF69D8E768EE8160439053866F0186C8B272526776677F82D08';
wwv_flow_api.g_varchar2_table(13) := '720A30B0340C2E623AEE2004194C86E3B5C3177574E4D89F6C6915736D156013F518279F16B930F9E04B2077B46F772438AA5F7A666B096478E1094D56014EEC5D4E47F8530F3E0219C1908EEC563F5047468A201F80779D4C90AD023C1D39B67819C80B';
wwv_flow_api.g_varchar2_table(14) := '4B2846BC00B2F2930F720AF0CC35AE0872A62BBBD529A8A3A37DCFEE08CD35988C170766DEE4ECD548D46066EF36276FB9CA3A78F20A71306468C447EC7A8B287D64F4D817771A90EF3FA19204B2558027F753A69259F3F22758074F3520C84EBB885DFB';
wwv_flow_api.g_varchar2_table(15) := '58276F16ED1C8E41EE4F10C856019EDA4F994A66AD96CFE7671520F71DDC758011AFE7919300736D15E05665B051AB1A061F562903B9134C56CE91D1AF1F7C50A95EF31CB2D9205B05B8A5195CC3E059650CC89893E1786D92401D1E3D0A907B01F2F3CD';
wwv_flow_api.g_varchar2_table(16) := '65B255805BCDC0C6E3ADC1C98AAB96BD673B86C91B95EB1C32203799C929C080AA4627AB0872E9200299DE752798EC2A3C6A7C668F61320A35C35CA70053F056A3502590339DED1B0B5A1DC9F73DB3B75920A70003E0291E3694083AEDA312C86E677603';
wwv_flow_api.g_varchar2_table(17) := 'DE2638DC2C905380AD3338D68212C870BCD61B90FBBFF850A3999C020C3C0C836B5826C5504EBCAF04D93D92EF7FF6538D04D92AC0B322A389A5D7223965207766D762D087F32F1E7CB851209B37FB6D49AA86A5A4ADAEEB6FA7B4A8ADBFAD712D944086';
wwv_flow_api.g_varchar2_table(18) := '77BDBA303CF23530F929B5BFF7BB74F0400C27067C5CD53A2F5805B8CEB1CCF1EA63405E931F1C3994EF7BF6F3981E5EE7BB9C5A7A670564AB267A8E2364E1F68A20E7339D6D6BD020BDEB7DB8AAF18B4690D9FEA3C614E018B686391004593C7F78348F';
wwv_flow_api.g_varchar2_table(19) := '478D2BC1E07FCDBF14812CF641B60A70C364148362696F021D8D752042908746F25827AF540580DCFFDCA386C99641B60A70636564095DFEF88CBF6CA8D04E9E4EB9A1405C86A3898F27DA2370CDACF00F7AC591E70FE6F26E47DB4A91004C7EEE570832';
wwv_flow_api.g_varchar2_table(20) := '9F44F5F16B0316925580CDE82D0CAAB14D40040C5552DCD10F58D83F9575CA0D05E232D3A90364593CFCC3036816FE65F2C3A3885DB7F788AFE9787D86397CA66C23766D1560337A8E2EE1698C221AC6B8F82E87238E83BDE3E8466E0EFAC3E606B9FCA8';
wwv_flow_api.g_varchar2_table(21) := '37AF7D299E42FD93FEB73F372073E954AE74B588F58E5C26511169931D80AAFD9C3B78FB720EBF611F882CA831A16199B1228DAFC58A4C4529BF162B4E7CADBC76F9B5F878CC1E95D54D19C878EEF291D1FC5F5FFADBDF7C7FF91FBF7886BF8512C11B22';
wwv_flow_api.g_varchar2_table(22) := '35A63B12E058568058A4309CD52303EEC088E8024C357E266C008ECB346A1F819DC11E1F8071EEC39B21ABD1F71979875F5188BE9551C360EE58804BEC51AA23E365E8670D8CE2F7FE1027411E8372F9797C3CD1BE1284B81CAFC7C713EC6901DA5C4746';
wwv_flow_api.g_varchar2_table(23) := 'FD821F147CBFB2A95ACEEF588029AC58CEF0A375D6E39918900B11C814783185D9E1697C3CD1BE58293A88CBF1343EAEB2C7A50093AECBA71F5E268426FE4C466593D33DB7EA644DB7D32495337286774B6726EB2A35AF8DEE96A8200014F47A1BB85573';
wwv_flow_api.g_varchar2_table(24) := 'A82A3E933163D1DDF100974B8C8C05C8323F8B6F39007908BCF12966B6A59EAD02DC0C79589243B199A6836C59885601B6AC7C45A137FAA0A9205B16A255801B0DC46CF637066448A929E6DAC20DA6004F22C422C86D98931B0572924DF424B26AD9ACA6';
wwv_flow_api.g_varchar2_table(25) := '806C515A56196C59F92CDE667D4DB532C85601B6EC1FD4878AE5DA0D03D9B210AD023C57191CEBCA189001C4AC385E9685681560CBCA17CB3551FB22C80886206C6C62D756076859885601B67AA3096EAC0832BC6B0F129C15265BBAFF14E01A054990DB';
wwv_flow_api.g_varchar2_table(26) := '18D604C856999C64135DA3AC5AB65A39C8496572CAE03AD5AB1C64AB4CAE735C71F514E0581275ECCB412693F9D240CD2975B26A16DDAC56AC0439298E57CA608BB097835CB3B9AE87FD55EE2505B88A50EAB9540419EBE49A1CAFD444D723FEC6D43520';
wwv_flow_api.g_varchar2_table(27) := 'E39510BE195233932D0D3565B025415636530E72DD8E5765E333384F019E81B0665A340920A700CF14B519968F415E9075CC9C5CD7126A867DB3780A700D429B6915829C81A49B01720AF04CD1AAB17C0CF2FC06333905B846C06AA9169AEB90C9647455';
wwv_flow_api.g_varchar2_table(28) := '73CD4216530AB045614EA7A972265705395D074F478CC92EC30F49135CAE93C7819C3238D9E04D67742469C86406439CB120A70C9E8E085BA34CA5B99E8D0714E91CDC645D28996B32193F664C4D749311B1DC3D2D720964CEC9F18724EC749432D88E1C';
wwv_flow_api.g_varchar2_table(29) := 'EB6A25069931EBD8F1F2F3753559AC7C47FFC2BF2885041C941C2F80DC86CF3878766C750A7002C0AD1C02990CE7DA4AB2D48C95B1A48D441220772D5968691106E396CBDD4BF33DCF29168C9AAE4B459A4E3DAE50CBFBAA68223C45DFA6FB29C650B56E';
wwv_flow_api.g_varchar2_table(30) := '632FB606C04E3B04CA4F3752B721540DFD0E46C3E371F2421996753AB02700AC1325D6D1FC3AD124C0385964532C65F5E2FAF15EE3BB64F1168F29CE4BD83EE100134C3031F72100BD05D171B800C85D8658DF221C5782C073805B0090F9B3C8CEE13C83';
wwv_flow_api.g_varchar2_table(31) := '8D1F8A435B9955C8EEC27115761BC5615FE750FCFA2420630CEE026CF3C3B6A82B46D9B04F604A36C06489E3895EB417D88291049B1F391AB9216AE87C783C46A8C8D300176575F7A3A8DB8673B44126C3ECAA41D4C9DFC439AD4179623EFB7245DFB50B';
wwv_flow_api.g_varchar2_table(32) := '8A00F0783E8EE950A002142C7F5DD4F0472243EFA2AF35F80DCB5294A765A0E210F1E4A4E4024C10FC417CA16CB9F8BB7F07825F8D73829711E7A3E3E2BDF19700044C326051B0103E011D3A25C1E63F127FFB63E17901E69CDF5F0078EEA9D7C53DFE65';
wwv_flow_api.g_varchar2_table(33) := '00B21CF5A80C513D9A647F4074DB12F17FE12909966F1295475FC6C4B3695A862805007E7410CA725D9C2B67C5F9F0DBA26EBD8D36313EF3FE4459D9B84E13F7C905D898CC8855F3164BB0102CA1D0336DA23ABB2174FA991066C44E336F1686A1008BA5';
wwv_flow_api.g_varchar2_table(34) := 'B07AA7048BC12C460B080E49E501FC353BC43D89EBA360B107969271C4C37C140B7D4159F4BC45A2172E83211829015C64250AC7EDE15AB06E87A8753BC5FB71BF38E7FE1D6B1B806C988C361392A0C6094E8665106A3E276A94DBB0D9C4A7F0CB866E84';
wwv_flow_api.g_varchar2_table(35) := '8EB976E4BCE8257B45135C00A446C034B0DED4CDC11A2C582AC18A3D00FE4A74D3403EB6A89143A6F2AC17F663FAE339E6746EC63C4323141447614C4CC1CAFBC4DFF56468DA472F4159A048466B4C76D3FF9449A9E963A93200D20B0960E2A3CAC6CC6A';
wwv_flow_api.g_varchar2_table(36) := '98DA31E01A16238FE656DF92A067A7E8AE45E6DB8434CBC6E132E021C6DBD609407684F5636F3AEAA28889E92BEC4367DA45DDBE0C86BE22DEF19725F3D67F887B0EE638F20D0838952158BC56820DFBA0381791C70663AD31A36FEA9F049BE80AB95402';
wwv_flow_api.g_varchar2_table(37) := '11671B7982BD707CA46B1B188AFF6D1DE65871EE05D39C6B3F0500EB60DA71AB107EB07C2398BC4DD4C04F716D61DC4A154CD030944A0D5C13F7C77F0645B90DB3BE56DC4C377C82E7C4BFF761E81914C1809DC114D2236EDB2A94C334E162A9152B50A9';
wwv_flow_api.g_varchar2_table(38) := '87A61C41F55B3DE1D3DE74B4F2172458FA80048B2064384264BA1ABE0527E80D98EBA1F01C5F18D5F3319FF7D04CC39C1AA6816D54126ED5122D47FBFD985F778A746C8413F713B4F97D987DB689BCB89E8B31B891A79F2006B73EC0005705989331F705';
wwv_flow_api.g_varchar2_table(39) := '3DDB45772E047BB16421C0B72E897BF615716E63CE35CE1800F6B230D3DBC2756C80720483167542ABCA7CB01FCB357160293C289099FFF9DF3C942A19AFDB87F3C67255D7D9D5B467F6AFB518C0315D62C180BD14FAE81598DDED6679535CE3C2447319';
wwv_flow_api.g_varchar2_table(40) := '23D75E1575F523C3EAD8E3D64BD6C3297A002C664023124165D371175C16E54E633B838F49BF83AB7978CF7B309F83AD70E0B4EBC1E9822376F543645D06C088BA99E55709FCB8A966ECA96ED6D24432B2D6411963C236C121765AB82C7AD97E04375618';
wwv_flow_api.g_varchar2_table(41) := 'F61AA10F2118F1310181CC2F9D10B5E921AC55BBCC87A07557B704AB768B7BF95B6190625CBBA61A8042E370B4F40AACA9611574C70209D6EE91C2DDBBC33CCEC158B639E74E8873F6551CC37B2FDAFB390870436FC92C8DA09F85210816CB9F9EAD088A';
wwv_flow_api.g_varchar2_table(42) := 'CC0B9751D94E716E5CC27F7201E6757D0AEC3A096FF82AE6E80566D944272CE8B95FDC77D6A23E963B1EC3971509269D4B2CAEA747F73D1D6682ADC6B346DF7CEF4233E872F17DF17EF435043EC070B30EC6726A2285A9E8A211A7564DF4EC33B8BC071C';
wwv_flow_api.g_varchar2_table(43) := '736ECCC33C77EF9060D927202F5EC32DD13C5F785BD4B53E734D5D3D2CEE05B0D9984E5E0AE08CAD06E070B6F270B64C34AC8AB8A9446EC6CCEB642F83258A269BD7E15D7B6F7E4332AFFD152CC5F700EE4A5CCFA39186AA7995418FBD6415E0D9B9B509';
wwv_flow_api.g_varchar2_table(44) := '5A25285C8AE8212C8D10B942108301080D40D4F06D30EA63CCB3BF8E38F636EC7F43E4F6050427868DE7CBEFF51330BD0AF370E162E80857EBC638668530A8113B64500E8DC817031DCEF91FC23ABC12811B853DC7CAB7E96756E7603B77037698843D19';
wwv_flow_api.g_varchar2_table(45) := 'E72232143B42113B14AF1360C48F6916839E2D66AE1446A0141806A6F9DB01EAB65F0BEB92715CD2A01DFEE70C868134D32BEEC5C3A59D508C41E4558882C56882AF9D13F7F477A0107761EE05E31126E51A3B58B24EF20F7F4132DF9F8F65D3515CBF07';
wwv_flow_api.g_varchar2_table(46) := '8E1CBCF984A58ABB6AE6E82051058F9860063075E64910F6D9C5000F8183D87921D3F83FCEF0111D820F7AD9AF223CB91EE7041D79DC432982457478CA129B67B89100B32DEC199C0896EFC5C38B97CD3C5E563A2CC3A5D620021D3F398888D54DCCEB7F';
wwv_flow_api.g_varchar2_table(47) := '23F9DD084B2222C6F0A75E8007213B1F97CC8DD35892BD87F532CC34E77413391BDB5AB3CEAC9AE8FA6E02E88C6299913B1F820096A8A11F8029884C75606D4BE08820F62A8767C3FE0D23C8A007F36FD75D8655261FA0907986FD647ABC616D4AE7CA84';
wwv_flow_api.g_varchar2_table(48) := '2FD9128321EDF3C2D0A51078307F5C8222705DDBB50FE1CF47C479EF1FC1E6FF31FD1244821C40B90A9F7C1235C15E826BD6C154A264A4043018A0D13961A062F94310DA009CA3FFC535086FFDD352D8F84B06307AB4141EE75175ED0C84790D4F7EB6C2';
wwv_flow_api.g_varchar2_table(49) := '3C6F0663711BCCA71384C778EECF4F213F2C6F185B64B6278595288F6088B1026D08312E63E81266FAC69BB8BEBC0A2A00AB0013CEF0A35A2AEE897E63DA092CA359189C14D6EF12E7E74F8973EA2B500644BC12F444A9C90043789CFB0A9CBBE02C6DDC';
wwv_flow_api.g_varchar2_table(50) := '0790EF4180E29C6149B0640D9CA765666D4BA0B8BE75AF5C1475E947C88777BB04ECE5736246AEC06E8627DD4BA7C57BEDF3384720C2BDCB280AFE472494412C59AE893C7A4CFC4FEC41693C28208BD1BE5EF180A8CB87D004C09928714AC8C052DCFCA1';
wwv_flow_api.g_varchar2_table(51) := '7827FF4BF2BFF8DB662A609043B7CF97C2FD9F86377D1CB1EBB398567AD0DF30DA6BBE816CFE08381F9A7917731AE74E30C3DFB8C76CC142062E603A09049FEC80BDEEFBAF634D7B126C5D01F6C24386990DD98DF992ECBEFC7E380F777C126596019435';
wwv_flow_api.g_varchar2_table(52) := 'D856607E841324F0B42F9E44792814E7497ADD6DED602462CD948479F506E331669DFB680B27F7B04E66A538675E12E7676F81BC213FF888B1B0748304F73D01602F86E032C266FC868934A631D7AD020C71D490683F51D3683B8E01A679DE0A936B62CA';
wwv_flow_api.g_varchar2_table(53) := '0C2E641181F273E2BEFD9FE29C86438470A0EEDE25C19AED0011ECE45A15C10D2E8F9C8FDFC6798F61B301D1AC71D12EE74630DAB9F47F2228C736594F321D30DBF7895EFABB30B958537BEDB88636395F9BB6B18F13974A1ED6C3F9ABE2BDF30D133CD1';
wwv_flow_api.g_varchar2_table(54) := '1D787180112DD4F3373F22C1A62FC0978005321AC37B6B6E0A55D0D2186ABB1D7ABF1010778357E0AD62E953D47EB498BB2DEEF50BE29EF92E98730C790086E679C12AC3383E0E34261AA038171092BC8180466609CC2F1C1E13F4E7A8C844EC5D28C1ED';
wwv_flow_api.g_varchar2_table(55) := '53E29E7F0BFFC527A2517C8180CB30CCD7BA7B3DFA07BB073E16751D0AC507FA8837F31C1D62C3184D7B680B8F05D5A5D7C47B779B14EE79D8F4CFA59BB1065016E7FC7A28011F2FCE43BFF02F4C7DEC9A90AC023C7306437034870418C0B9275F46E8EF';
wwv_flow_api.g_varchar2_table(56) := '243CD6A590274D2EE63D042C9CEB6F618AFEC008D62C9FC02275ED9464BEF377A80F134E01D2E4E6AEE31C46890AC2768B82653F2867965E0571DFFC1771DF5D5C56177558D75988B0E33F0318CCDFF1B8F28368876D82D5A6AFC8DA788B30DE1761AABF';
wwv_flow_api.g_varchar2_table(57) := '178E9F79C65AB05BF46FC6108D0D979A95AC025CFB4D5068F0907360CFCF4E409030851496111A84E576C371D9806BE8C1E4B12C965403F0968D2964CF68C30563CC6BB193A81AFB194678720073B56125CB62F316A229CCF3B7388793FD0095AFDB3A9D';
wwv_flow_api.g_varchar2_table(58) := 'C883192EAE6D39082A25C605E6ABABC771CEC4EB1C374D3B9C3B133829573253A8E17FAC02CC5BAC3D51C80088739C611FCE8D5029682413968C05863C320A512C5386CE10CB52210CCBC22AD5FF46FDF06D0ED60BB5266C9F40F37D6BFA03C536D1E7B8';
wwv_flow_api.g_varchar2_table(59) := '650FEF147DD1BCF3F9B069874D710C71F9B8EDEAA368D455AB00F396EA4A069C32B36604C7F35858E52A846B7C073AEED4ECCBF32719895104B06D4C8AEA1A458A1A9DB4CD184C2EF1A23469F9B85063F756019EA678A7718791808B25276A79A2EBC58A';
wwv_flow_api.g_varchar2_table(60) := '931C4C5677B2BCCA266752B6B2EEEC9F47F6CF4E4795B0D869356DA51E09580538D9BA5C8F985AB7AE55805B570C7377E429C073175B736729C029C0D39740EA644D5F561395B42DC3BA18DC7FE244B95FC5686F9AEA9440A50C2B643CE3D6EB0278FF96';
wwv_flow_api.g_varchar2_table(61) := '2D46E15460B035AF3BCD78046985311288191CC95462198F29348393BA021DB176E12D438D873371C08E638CC73983A1A44529372344CA1232A5446219D72A9DFA18BC3FEC563BC107CA51EF65BA10800F03C90C1AA7DB8C65A003CA90B2EC804C29DDFD';
wwv_flow_api.g_varchar2_table(62) := '918C795C4BAA34F9336A03DAA6105F379A36F495CF3EE1B8EA856C077E5FC95457CB331AC6DC281CD9BCDCD0E84D4C78BFD7F9FBDFC2C36F52BA24E35A6EB46E18CA0730F4D5CFED5652784C2B851FFFE880AF22A7696A099817461DF056EB1B78ABEC95';
wwv_flow_api.g_varchar2_table(63) := 'B63FF8E60F58AB5CB653B7328B253890596CFE8E6CDA964CFF1F8932F39E2771DDBA0000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72350886691797178)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/jar.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D000017E5494441547801ED5D696C5CD775BE6F166E3343522BB55AA62CC9B2E4D8965C5B56632BB25BD45D90C4B2C2A888DBA068FBA729DAA24551A0E80F';
wwv_flow_api.g_varchar2_table(7) := '134580F6971BA440D0D428102411659B6D6354492105ADB5D8922D59B6A1B48921A8B6166B5F289233DC667BFDBEFBDE1DBE19CD90B39C21DF50BCD070DEBBCBB9E79EEF9E73CF3DF7CD935212C9B62D0932B34AA3B737A0E6C2380A84182AB8AFFC9642';
wwv_flow_api.g_varchar2_table(8) := 'B12C9B0DB71F3DF0246EBF642BBBD3B2ADAC0A544E6EA65A90BFACB25B9A03815B8B236DAFFEFBD6CF5FE8D9B429D86FDB59339E99E2A59EFDD4A6791E70B71D3AF89540C07A35188B762A05BCADDA48D773D0867616176DB6AD3AB2D98360F91BFFF6C4';
wwv_flow_api.g_varchar2_table(9) := '339FEE3C74287478E7CECC5C01B9260DEEE9EF0FF42B9579E6E881E569A57A431DED9DA9C1A1148415507EC697F6862A8C7F9950702C108B3E9F4DA5FA5EF8E8DDDF7E73CBF6F31A64DB9E13208B18D1543ABBD656D686F4701CCA6B135CD2F5EF47F347';
wwv_flow_api.g_varchar2_table(10) := '136363825B0AE026C21DEDDB02D9F4DE9ED347BA0F3FFB6C7AE7E1C3C1B9B026D704707F4F8F5E7B6D0BC2CA1258C88CD7945A237C34BF7610405BC9E1B81D8E447F3993B4F6EE7EFFEDB57305E49A0086892690CA0A06A1C030CC10181C2C66354622AB';
wwv_flow_api.g_varchar2_table(11) := '5883C1B8F6A053F17826DC1EDB0EB7B16FF77B47D613E41E5AA206F6AE6B02D868B0465343CC3F0D90CC1C9C64D6B6021005AC4F2A9EC88463B16D7638B89720F75B56A691CD754D00E741698C725EA64F6F26817518D4F312A8D37F00CAA9E1E14C381A';
wwv_flow_api.g_varchar2_table(12) := '798220F77C707C5D236BB21CC05A5434D10D98F43E1EBCEB6FED4B0064986B809C51D9BEDD1FBDA735B947F5379CB91606B8C14CB4998B7A8DCDE39D0EA30372049A9C4EBEBEFBD4A18DFDD657338D06B230C0B07246687EFE3626DA306B34389F6707E4';
wwv_flow_api.g_varchar2_table(13) := '04D6E4F6D816A542FB769F3AEE82DC388E9730C04672F992F2DD5D0E589733D74B2EC23DE5A33539148D3E86988E0BB2D5309A2C0CB0919CEF20CD67C820892D924E6E2CBD04F7394D26C8B6CABCB6FBE45B9BB5B94624CFEF5B2859804B48285FBA3EBA';
wwv_flow_api.g_varchar2_table(14) := 'D33199B2F8713499E63A1A7DD40E845FDBF5FEB187FBBF8A35D9E720CB025C96AC7C54A9B209E980CC604834FA30947E5F23802C0EB0B17E3E82519215C75C6B90230039EB7B906501D6A14A4979D6995675B331A0702EAAC39A5180ACB2AFBD70F2D063';
wwv_flow_api.g_varchar2_table(15) := '3973CD07077C948499C9DB4BFA689825583126BAB4175DBC21235E043931920EB747370702D842BD7F648B0679D3264BF908645980213023B3E292F159AED160D78BAE883B808CB10611BB4E8763D18D0866F7F911E49A0EFCEF128811D85D053ECBE02C';
wwv_flow_api.g_varchar2_table(16) := '24AF05B3D16497CB2D48F059A51CC800BBEFC553475FEAFFA51D1FF66202F4F224AAB7970F8ECC5A12D7E0591B49251D4B4D44ECA3F3408E463702F37D2F9E3CF6442F3CB0DE975FC6732EB3BB26CB022C25B84AC0AAA6AED1DC5AF9E53EDA05196C0493';
wwv_flow_api.g_varchar2_table(17) := 'F138CDF50615C8F4BD78F2B02F409635D11865AD32AB06AF8ADB18260DD0DAC9329915529B0C96E078C20AE2C99074532CB62E3592D80B905F8226BF3F9BE65A1860E7B8B04A5155285981EA86D16A9CACE2DD6B905DC76B7D2A11EFDB7DEAEDDF01C827';
wwv_flow_api.g_varchar2_table(18) := '660B6461801B649B44CD35E012285783BD59C5F12B2B17CF89D3F1D2E67A5D2A3EB26FD787C7A8C9EFCE06C8C2003B8EA990A0CA926655950C83C6447B0E1B4C515574271BE1A15C0B20639F1C8B74A712893E80FCB5D90059D6C9CA538BC9D1FAEE2A07';
wwv_flow_api.g_varchar2_table(19) := 'ACCB59A5818E320684890290A1C90C8644A3F7E3096C82BC1D20C3BB068119F2AE850136922B4302B359C5A869DE71A1FCF3A00419C374408E1064C4AE4FBDF374AFE5EC8D7B67006459801B04DFDCDC9AF480916550CF954A5D38208F4093239135969D';
wwv_flow_api.g_varchar2_table(20) := 'C53EF9C80E06407AD143AF5DDF7DB22CC0522299293A3337212735391A5D8538F60F27417ED9A6F355AF218B13AE9B1ED44B0239BA7547DBF1AE1D4D5E9D03190E5E2F7CD37A812C0B70431F17CEC8D4D49A9C4C24D2A1481B41EEDB75E2C873AA8E20CB';
wwv_flow_api.g_varchar2_table(21) := '025C18BDCF69874F2FF29436EFA69E0CEB60487A643485E7AE575AC1C00F767D70AC6E20CB014CF9CC988C84E46F945636D0510E73EC39842D540A8ED70A385E3F7CE1E4D15FA98726CB014C968DC0CA19A21FEA9809A97F33E7DD26A1805B28EF87FC7A';
wwv_flow_api.g_varchar2_table(22) := 'EF0BAFA72A37654605D8D69156283532920A4522CBF1FCC0F7777FF8F6AF6A90B157EE79E30DFCEAB1F6240730793102AB9DAF19A2906398AFA14064C2BC6B0433955B28EF871C79EF0BAFA72A37650EA80E1DE639F76144BA100C89ACC0CB23F6EEFAE0';
wwv_flow_api.g_varchar2_table(23) := 'ED5F67019F0E910886C802DC281AECC515B006A031C42B100C66AD000250A53E7086F2CA4ADD17E6935E611EEF755EC00E0402C1F4E858B2291A5D1AB4ACEFF59C3EAE41E65E1956A326A98AC7A26BE286537726129904C8043595CD06E389D171A5B209';
wwv_flow_api.g_varchar2_table(24) := 'A3608E293223E16CF05E9341EFBDB966BEB76EE1BD9955A6BEA9EB7ED36CC713894028D8954E265F79EE3F7F74F6ADDFDCF589794D06A9559384016EA0E342C899A24EDA767332950ADA6363B6CA66F17207E4668DF0A713A9A957F8CD7626AF140D6F39';
wwv_flow_api.g_varchar2_table(25) := 'AED12F300EE319A00CACC44301DB5E85969FE4FD06BB14A929F285016E90E3422310C8155A6CA9A6E630CCA502C8C0059941D995CB7437DD37D5C36A0AE19D21E974CAB6F15E9BDA931CC09C9048FC32464867F8F90F19D57C5377C29AEF1CC8B4DFD325';
wwv_flow_api.g_varchar2_table(26) := '4E8672EA15A353A42D6D07AC4710DF5628EC42E3BE26A3188972F2E400D6F2284328E57035937534CB7064083441C6B73D0E4DC66BD2CA028F40559B0ADAB2C7BB6C87FBA29B6ABBB88B5EB5849C76350CB6B68E655A53E004B9A5156B22445300804C27';
wwv_flow_api.g_varchar2_table(27) := '5350A9437FB2003738BE8EE8671364790B280BF01493B3B18A5C905B6749930585250EB0FC1C141C6D45A4007208E67A0641AED65F9B6A58B20073AB31556F0D57E6823C436B721D9660FC764634CD2D781DD1604C74BC6650932521910398D8CE457CB5';
wwv_flow_api.g_varchar2_table(28) := 'B431B01936D75220CB01CCC577EE2CC045E4DB989A2C073045326735D8C5DBEC93EB66AEE505280BF09CD6600FC87533D7F202940518329067D115ACAFBEBCE69AAF9B96D73CA9E10A033CD7B64953883967AE5BF8A4806F411606D8BF33790AA8AA2F22';
wwv_flow_api.g_varchar2_table(29) := 'C8DA5C4B812C2F3F6180EF1513ED9D130045EF932540965FE08401BE874C741EC692207B09D77E2D0CB0BC89A97D883344C1A76BB230C0F7A289F64CA0DC9ACC53287F385EE200DFC33AEC224D731D7263D7B30FB230C0F24E82473F1AE7529BEB6A4096';
wwv_flow_api.g_varchar2_table(30) := '570F6180E5196C1C540B38AD06E43A1C080B037C8FAFC10518EB0817CD751BD6E4E0F4E6BA1EF64F1CE0791D2E40593B5EAEB99E06649B75859338C0C2FCCD0D72042E580EC8F23A2C0EB03C8B7303637D961A2A0764D9F18A032C6F6464073CABD4F89B';
wwv_flow_api.g_varchar2_table(31) := 'A7B234598E4B7180E5589B8394B47903C82535595E3D84019E37D0654D4B6A723190FDBF4D6AB05F179685461D2A510F2AF0AE6BE1405C83E58D4C2DC3F379DB4290F5EF9265791606781EDE8AE1F1986B2B347D30A452FAC20057DAFD7C7DE747C99E35';
wwv_flow_api.g_varchar2_table(32) := '591864B9DF07BB58CDBB59554E5A986B1BE006426D4AA5F14BE154AA4A42F9CDC43578DE48E70BB8A23B1DF182996EC5E33FFC20F5EABFD5FF11D7E0EA59996FA9256040C6368AA957FFADFE8FB006CF1BE8EAA1705BEA2D54CD5472048435B87EFBE0C2';
wwv_flow_api.g_varchar2_table(33) := 'FF3E8C72F04EA7C2F2DC083D17A6BEF9F61495BCE49263961DAF3678F30B7929496C9A821C5FB98B691A94512C0CB0F354A5207F5AB858955404511E0A988225FD095C4CB8A2677E14E5419478DF38896C9D589F1380EF254AC3049AF7134DC5A701B509';
wwv_flow_api.g_varchar2_table(34) := '349BDC8ADCD1900E6FF9E12BB59852C84F15EDD9292FF72FFB744996DB64DA7AC2001BB14CDB6F5915488DE04D0094E319C0E221BF0E2F49598A0FB3D2F87318E559BCECB1A48820B9B598044BF01E9B08DA1194245A1713286936A384EF331AC4DB763E';
wwv_flow_api.g_varchar2_table(35) := 'CA649CC893AECD5226B725BE1E06CD185FDAE2C3240C706ED82243A5C8F04230D50EE1FD4173AB6A0640D450BEBBEC5A3AA52EE2C3EB16E47FBDB54D0397417DE679130FD2C700FE956C46FD37B61FD954523D82539D050066DC0332A1639FADA0770DA0';
wwv_flow_api.g_varchar2_table(36) := '7E8CFA1B50EFF75A236A4553B3EAC4AF185AC10BA7D128CA86D26975239954A79313EA3AEE97B965DEBE2BB9CEE7BA9296A5EB0A032CCB227E57AF3E81E0BE0C01FFC97D6BD5C2709336B12100F35F372EAB3FBD7E592D409DC7C3CDEA1BABBAD5EAB6A8';
wwv_flow_api.g_varchar2_table(37) := '1A8326E3E5A2F923A6B602E0214C88DB13E3EA67C3836ADFD0803A9B4DAB758150CED47329A0400EA1DE7680F9AD454BD5A3ED0BD42A4C9E36FC7A81FDE265A198124A7122A5A1DD13E8EF1ADEAB75F0E655F53DD05D0D90A1EF35A402DE6BA0C4A6C200';
wwv_flow_api.g_varchar2_table(38) := '3B2BA0148BC4E916C4D902A12DC17B3216418B28D4309E39EE0835A96148BA19E54DA8B8B8B945750188516855D079EF634E8FC9154159E5E63CBE70897A6270407DE7CA05756C624C3D009033A841BE8F02B03F8F75AA3DCB56A9F5B10ED58AED0A2D40';
wwv_flow_api.g_varchar2_table(39) := '161F6F625D1B8FE0049A9AD4CA48545D1D1B5517076FAB35AE16E7D7F6B62C7DCD36CEF4295DA7D2126180A5A07586419922AEA3B5653C9D516381343438ABB53809CD660AA34B0A7F1C2695DAAB3558BF53946BA8C30FDF43C937D825A1B114622B26C8';
wwv_flow_api.g_varchar2_table(40) := '538BBBA09196BA78E1AC8A63D2D05C1FCAA4D437172C512FADEE56CB31A1F0265A358E09438B1006706CCBBEB804F025BF9A3AE9A26FF225038FC33388892461801D2D10E10C44880F61E49029E42040A090796DCC30C5CAE4943BF9CD00F0C268429D86';
wwv_flow_api.g_varchar2_table(41) := '1966FD0E98DB072231B5B22DA2B5711C13A1053EF7E6CE856ACFD022F517B7AEA9C55859FFBA63A1FADDD56B55574B8BB6046CDB022D1D0380E78687D4C5B1119570018F20ACB8184BC332580D5A97264C803C2F10779526075AF62A9784017686283907';
wwv_flow_api.g_varchar2_table(42) := 'F36919633B29006FB9160D340CAFC7579700C6D7AE5CD0DE6F37007F186BE85FAE5AABB62E58A4420083DAD904F0B6628D5537AEA8A75ADAD49EE5AB016EAB1AC11A4CB89A51FED9E888DA7FED92FAC9F01D7506E05ED55346A9959876780FBFDA8C6563';
wwv_flow_api.g_varchar2_table(43) := '0726C64D385A6BD10F23C86C5B4D22FFDEF15443A3B08D30C0D2EC15D189722638EA04202A6E5F820024068DDF0FA0D603C88D5857DBB0AED23B679D0E00CFDF11BDB060B15A1BEDD04E137B6D86F77C116DBE75FEACFAA7F8A05A87FBFB4067AD6B45B8';
wwv_flow_api.g_varchar2_table(44) := '9F4E6092BC8EB5F7F5F151F539D020E0DC6397C362211093F7B2321406B8B6A14D0E728A2B0879DA842AACD60C30189A6887F01F81077E0BDB23AEDD112BAC4160A0228DE8C5F370D01EED58A0CDEC482AAD357B1466F93FAE7EA6C1FD02DA72BDE6DE19';
wwv_flow_api.g_varchar2_table(45) := 'EFD8D71383F751905F8E1EC601365E2CAEF8FF0294C1DD34ECCBCA501860791373973420486FCABF734BDC4CBA54D4E00938403F8379DD81353804B0E9151B20B81EAF87995D0AD3CC40099BD2849F890FA9FDD8F65073F1B670BDCFFD1F686C5E626543';
wwv_flow_api.g_varchar2_table(46) := '08970F61422D40DB825A794DA6BAF1909AAA5A4565B20063C00563AE88996A2A17150A3269424F033C3EFBD4042DED8659FE8D455D2A826F6EB5E894B1CE79ACD55DC88B718F8D7AF4BCE9299F8793F673B4DF80FB5BA8FF39045AFE0C6B2DB7647ACB84';
wwv_flow_api.g_varchar2_table(47) := '6F264E16D2E2B83FC4A4383012578BAB04B91EB29305B8A8B4B51CE4FEB8829D8A2001580AB3FBCA92150020AB03249BA2ED6A7D7BA70687E55C876F21E8F1E33BB7D4735897E979A760BEB9A562CC791811AF01D4E31EFC7F61AEBF080DFF229CB05638';
wwv_flow_api.g_varchar2_table(48) := '5E9C185CBFC90A41E1B5FEF7D939F56DACD75D68C37C7E663BC9025CE71169F2102E53C9AE20756A6837820F6B10D9623DAE978C42397B55ECADB16D1A8576FEF4DA65F57A62587DB97391A6481FDDACA2D44CD30B0F350822F7C261D0C1144099B327D6';
wwv_flow_api.g_varchar2_table(49) := '17BA17CEEE925C39D566E1AF2CC075D060BA497789CD93E1E27D97E8B8676E768F7B3454F84380A89DD710BDFA29C29C7F77E3AAF6A0E9209918B65E9FD1690BD65E6A33F7E131404AAD653085FC18139F83D45565D2F65B9203D81D5CAD181B1969E1E1';
wwv_flow_api.g_varchar2_table(50) := '660412E3210365A813BFF1C9DD9A0BB7985FCC627469844E1368300C49701230BBE746E3EAE0C04DF55DAC953B00E279D4B906EF9AE534BF8C59731D5E89D71572EB130781F5C8FF05D6E4BD17FE4FAFC109D4DD80C0C9B3CB566A078C3C93BF1C8F64C2';
wwv_flow_api.g_varchar2_table(51) := '27490E6057D07AB0350CAE05F05050D42A9E1211A1C530A92DF47E355D3834B8486A8F76D2A4E6BA446108807C8CB5F0C7D7AEE83598DB97EBF0A23F4630E25D80C9F3DDA701AEDE4681D639ACC5090437A25897499B6BF40358B39F4694EA3B709C7E0B';
wwv_flow_api.g_varchar2_table(52) := '5EF60594FFE8F60D67F6E0FAAFB05EEF5CB602BC62BD65A3BC446114E6E55598B11B39805D9639B44A134541D34773F811D6C6767CAF0148431022FFF7930D584F5B014806DAC57A13C8BF0CB0BA5C3D2E14254DEB1D1CE37D73E8B66ECF1F5F239CA11E';
wwv_flow_api.g_varchar2_table(53) := '0418CF00446AE81840C17F3EA536C16C9F42A0E232821ACB01283D62EE951702D43D5DABD47B3829FA0926C0761C6EFC1AF2684D4E824E3B6896C6B09023745E46AA4676D39115079843AB8451D627133485CB20B4DF8763741EE0BD09A132FD0D4E7E1E';
wwv_flow_api.g_varchar2_table(54) := '47948934A9598CF90E420B7F81EDCD5208FB6609293741E33F8FAD0FFEC3497D4ECC6004D748EE8D691D488FCE5317EA1D4A27D5BBF0A63722D8C1F35E4EA00C26D663086BFE03EABD71FD927A1313E032EAE904138DFF7810DA0B2AA0757722F562F977';
wwv_flow_api.g_varchar2_table(55) := 'D7F4E6B0055B4A2671802B658E8362206100425D6D85D48B5D2BF5B1E01F618D64ACB81BA692C784299BFA0D4D0700E750F6164284DDB8BE8A76C544498F78904002287AC68E27AC49E40991A1C52DB00EFF82A3BE47063AD517962E5721B44BC15A8460';
wwv_flow_api.g_varchar2_table(56) := '2F1E5FB858DD070BB2077DDEC1C44B6196B481AF55C8A3774EAE349C68338975318E9CBE67FAAF38C0D5CE409A506A5904C27B10FBD53510A0DE9040D05C6F2932EE5D072626D47E78BF1791FF1026C4B80B3CD7417EB881A1A6535B69CEC98FF9E0322F';
wwv_flow_api.g_varchar2_table(57) := '319FC0B7C3E40EE028F11FAF5CD4EBF056588D50D6D56468EB92269C3523D0414F9B9C1058F2934219FBE37D187C3B274AD56B61B5B2CB1B54C10D652097306A0EBCD2C48165D0900FCDF19ADB100A8F6B21B72734B711385AD4A0372E9F57FF0CC7E729';
wwv_flow_api.g_varchar2_table(58) := '1CD253D8097C38086A3B0F089AA1D53CE2A3B0C98BE6670AC9B12D1FDBB91FF43E00FDBFBDF0893A78F5921A8623D58209455A5CFBC90B83263C57267F34E1ECB30D7DF20104064D3EE3FF9806B09974BFFAAAFC3FD5B4998EBAAC06636C53C8B2282FAC';
wwv_flow_api.g_varchar2_table(59) := '4F7079E2C36DCD7508EA7E385A5CDFCC80075213EA7C22AE0EE0DCF6151CDB3D0AF028471ECD2DC705D7D4AB106E10021F83B7DC82ED108FEFF4E048C7102ACA81C333417E10609D05B07F7CE99CFA3ACE927760ED5F83ED101D2E0DB46EEF10A336DF1E';
wwv_flow_api.g_varchar2_table(60) := '1F5703C971F529783B86FA27E0176C030D991F9D9460B6C26C598031760EBF129059974F37F2C1BA7168C57761268FC3E1E1F357A49404D81701D63BF074195BDE0E0152EBB876F269CBD530AF3791FF6D8042078982A7973C040BD08C3AA4C1475AA7E3';
wwv_flow_api.g_varchar2_table(61) := '89E504F93E68630213EDEF3191BE0F4BF124C07D109F45E08781124E3C6A301F0DBA0467EF0C26DF3B9850F404B6A02D1FD833EBB2EE7E96FFC8025CC3603831E86CFD1C42D31E7401229B00240313141EC16531D73F82498D3981E8D41D10E12F7A26F0';
wwv_flow_api.g_varchar2_table(62) := 'A1667702906991455D930CC86D68BB3318564300FA242CCA9BA00DFCF269E1BE150D9683AFADE827826F7AE8E4A58075437E56BE65011618191F3D5D014D30BE3149D2D962A243E4953373794F8D5E8335B41B1934C7C047AFDD9C089526D2E466880B44';
wwv_flow_api.g_varchar2_table(63) := '0CA07584026A1D68B267F6651279625D7E08EC985BCA7B3F255980BD12A8729446B8048D89248D708D407541C11F82EFCA587FD72268D3D6D034FD9A7CF2C409E81C39388C98B202B666FD56166081511A125EE1514A26BF94C4A62B2FD56EAA7C2F4D67';
wwv_flow_api.g_varchar2_table(64) := 'A2E5D7F696E797F8E7CE284AED1C159340ED54E729D428013980399D1B614AD728B0466B2E07B01EB9E378349A10FCC2AFA31FB25A220CF0A49FE317A135121F5CE5A49330C0F560517AC87EA7272B4339805D274BD6C0F81D0C59FEB4EC64F1D53182AA';
wwv_flow_api.g_varchar2_table(65) := 'B9ECE9EF9FC4939101441884F9AB9AB7466CA865C7280DA3356ECA93B1C9ACE0BB260DEEEFE9D19CD8998C86978CCDBB591548BFA0AA969D1B8AD33245B9917141D5B26F6B02D8CC2E3C354164117002DECE034A047EFE53A90C9C436D82676B99E2C2C8';
wwv_flow_api.g_varchar2_table(66) := '9899D5249148562A14F814673F6742EDB1CDA9C121E7747ED27857C3D7BDD786EA605959C830981E1A3A13824C2584501B0C367E066DF1085CA96D870E7E054FACBD1A8E453B3563B55196185B63D1D052C4C1C5707CC80EA83F3CB1E3F97FD503F0C8B8';
wwv_flow_api.g_varchar2_table(67) := '9A01D50E838781ED470F3C89DB2FC156775AB6E53C02590D57F75A1B04DE6193F198BE3588538CFDEF3DF7FC090970E5C44890E793AC048464FAFF46A2BED28CF7B2740000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72351316374797180)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/jpg.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001426494441547801ED9D6D7054D779C79F7B77572BAD561218221B1B30603004E3DAE0C1041CC74ED2B89916E1A463B9693BD32F699BC9F45BDB9974';
wwv_flow_api.g_varchar2_table(7) := '3AD341CC341FFA25FD9099745A7BA69E021241C9B4339DB4F587DAC46D48EC80B09CE249B021C438263601845E562FBB7B6FFFFF73EF59DD5D4948BBF7ECEA5EB1C7DEBD2FE7E59EF3FC9EE79CE79CB35C899808AE6B99286659CBE8EBB3C595F8B7A342';
wwv_flow_api.g_varchar2_table(8) := '88E11B44B896E5B2DCFDA75F7CBC5894439665AD72C571EC8A8789F08E838F8EE1796508A6A9367EA1BCFABEFF2C8B2C5DC775A4B5D5B67F9D6D4BBFF01F7BFEF017BDEEC9C4A0F43ABA3D95358BE3753254A50370F7FDE085E71C475E4C75B677A932C3';
wwv_flow_api.g_varchar2_table(9) := 'AB4EA8AA2D2533D52709D54C16DDC7BE706EE0AB83D6F3979F7EB52F79CA758B2B057228C0BD32680F8A141F7BEDE83A71A7FB52AB3ABAF22363799887AD3A3BDA35412BFBF6CF71502118579966BE38AD30BA2C5DCEEDF256A6294F6B39AEEB1493C949';
wwv_flow_api.g_varchar2_table(10) := '3BDBFE79375FE807E43FF8B7DDBF0FC8B26220EBBE528BA2BA23E832A4647A0B286E2F8C4E1026E1B2DCF2A3BEE7F5CFE5713AAD4EB3D031988E6982E982E795E9F4B53E7A69895B29B85B288CA7BAB2FB01FC78CFF0C9CDA73EDD5778FAD4A984AC00DF';
wwv_flow_api.g_varchar2_table(11) := '2214E0C1DEB7953DB976D112D7E2588C83B2590A2FFA1FD65724E1C2B99A199D70531D990376B1E043FE34201F893DE45080657027218AE524E87FFA3E68651FCA14510DACABAA36BC2ED7CA8FE68AC98EF6FD84FC8533271EA02573188AB3258703EC5B';
wwv_flow_api.g_varchar2_table(12) := '30FA684F4E8AAD621E55A215F5F2EA0AC4AE65431438E4C7261464C72E0E1C3C777C1B1CAF629C2187032C87CB051627B6C19AABB116DA49FF0198F3A313C5544776AFEDDAC70F9D3DB935CE9043020E4A29C6E7FE3CDE9F1AD179F321B7ED15ABD81F67';
wwv_flow_api.g_varchar2_table(13) := 'C8E600FBD61B4B239EEB2D7B90C772C55496900B270E0D9FDC1E474B3607588DBFECE56218B4059757DDEBAEC701B923F398140B277ACEF4EF881B6473806369BA3ED1B916AC517B90E15DA7B29947B1C2391037C8E6006B91C4E98809B00AF35BB06E89';
wwv_flow_api.g_varchar2_table(14) := 'D75DD39209392103CF0E1DDBA92C7930FA5328738029ABB8F5CF58E85862F02C9990DB338F3AAEFDED2F0E9FD835F83CA65011876C0E3025B564792D51ACF54E569D429620B7746676398E33F03B31806C0E30E14260B1625C7D653DC85CF16ACFECB20B';
wwv_flow_api.g_varchar2_table(15) := 'D1876C0E30AD0102ABCE28EA6DA27529DFE636471E53A8968ECCAEA4E30E1C1C3AF148A9BBE60F072214CC55A67A6B888E1816F6A2E7AF2356BCB0A962E7C7738564B66D97ED3A270EFD7860B782BC13EBF311821C12F0915901D074E36ABEB7F7A267DB';
wwv_flow_api.g_varchar2_table(16) := '1838833E53A513B0E442AA33B303C8FB0FBD193DC821011F9E6D329BCB4F1C8256447DACBDCE1EE4511F72D1EDEF3973740F2DB9EF306413014B0E093820190A2BBCC00205D6F1542BA2F753B2B00FE20EB867C91D991D969D18E839776C6F9F65397D60';
wwv_flow_api.g_varchar2_table(17) := 'BCDC90CD01A698B4E0C28AAC61F98D55D8B36476D71D9907B1EBD8EF41EE5B76C86601370C8CE10755EB64CDFF78CF92D95D67DBB75AD86AEC798396BCBC909B8009AB06276B7EC6E8C374779DCD6CB39256FFB36706F62D2764E3808D757A0B48B02EB7';
wwv_flow_api.g_varchar2_table(18) := 'CD58B0AE5A09721296EC6283E2E050FFFEE5826C1C705CFC2C4D431DCD59B02E56412E78F3E4CD1072FF7241360E58B7305647B316AC9BAE1C2F1FF226427EF68DA3071A6DC9E600C7B16F5EDA76A10656CBD1873C5948B6B76D9264A2FFD9E181270999';
wwv_flow_api.g_varchar2_table(19) := '85F535609E6C0E709CE6C11AD5D2B70B758E5A8E1EE489C94222DB76BF5B748F1F1A3AFE29D075FA505A9F5BDFB56B7380D9F4B85971E31C86A0256F80A08ECD423EECD613B239C06C0204162BC68DAD6C3964D73AD633D4FF14A7687D523FC8E600D31A';
wwv_flow_api.g_varchar2_table(20) := 'D084C61905BB8CD805E55D172726F3D885DA0071F5F79CEDFF4C3D219B031C3B59A3C2CBA38D5C014F1608B9BDED5EB801477B86839031733618421676A4BC2ACB23B0F23A5473C54E93A13ED324AFECF9BFF9E459C845397A7068E0B39E250BC6647390';
wwv_flow_api.g_varchar2_table(21) := '43023E3C5B7D56590B6CF66EB4CF4AD3249C4039CBF493178C5747BF19FABC74E409822EC7BFF4F2E042A75369F8E56F5F79E97CC83965C9F8176E477BCE1C7B4641C64E54EFC99309E6081B42020E3C3ED898C0ED789CA2A3E4FF414B560A8B2F75F45B';
wwv_flow_api.g_varchar2_table(22) := 'A1CF4B479E20E8E9967FE9E5C1854EA7D2F0CB7F97894EA75258A9FC38E6C9D9CC3AB1ED6387CEF67F9E29B9A76C62ABD11C60D66AB6E2BC8A6EF02C48D58F58F14E11878CAC84ED5836FFA561E0032FB7ECDAC6AF75D43D7DAC8C0F5C2F9817694A71F8';
wwv_flow_api.g_varchar2_table(23) := '276EB69528E626675AB2998F5909EBA52F0E9F549039570E3B7C847A854374092E52332A222043C852709CC4C4F8E49425CE78807B45017E868ABBDEA58ED3C7CA440BDD673AC4B17BA776E1688DE5C6AD64E2EEE24CE11B07FEFB1FDF39FDD9AF5CE4EF';
wwv_flow_api.g_varchar2_table(24) := 'AEF99A8CCA52977A7D6702F6654BD1E75D379D2FE413929BC68B81F8533ADC5C98F452E55A7D3A40765D37853A15A1781FB72D6B3D0AB9A8DFA2507D815E0EE38029B4D804CF782C49A752CA8A72D39E45D9BA1524ADCFE76B958ED7C7609AF9EECD173F';
wwv_flow_api.g_varchar2_table(25) := '9B4EBD24219514BC10A6006D2B0453D77A1E12F09139CF9DADEE9CA8E8DD203B5618239D40B092C1B986ACBA4D5C2F85AF4E54D6F8DB65F49FAB92CCA6833FE0A01781F7CC87FB4EF4E0F9D904C8566D08E9641DAEF679D14BAFC487AE991E742A69495B';
wwv_flow_api.g_varchar2_table(26) := '0BE48CFF1C8731DE7DC6CDF7A98CA7973C5FBAF9EE55E6451A47BD2EA48267EF43549B9A4348C081E756D42B10139F533A3CB4E4B6345EB88406E9F96D7C5A30A7A6E60053CF42E9DA9CBA2DDF8D1504D91C60E2580956ACD56A85403607987061C12B89';
wwv_flow_api.g_varchar2_table(27) := 'B1B434B6BBA66B653A9803CCEE19155C29BDB412341BD3404BAEC7906F0EB069D58B5279CA925BE178415CF5A050C7B686047CA4BC6A2BCA7C034D63BB083943EF3A5E9043023E3C2B058E1F751843661FB0CC676A0A85C58798410E093820746AF94AB5';
wwv_flow_api.g_varchar2_table(28) := '60DD4CB62F556FC86685680E3085B0922D380839594FC866856816B016C29D70A4771D83EEBA09B85665E4985C574BAEB562E5F99A80CBE551FD55C4213701578F746E0E0D390171466C9EDC043C17576D77E85D73172A62909B806BC33937979E42450C';
wwv_flow_api.g_varchar2_table(29) := 'B239C066BDFBB9028CC39D08423607D8ECFC3C0E38E7AF63C4209B033C7F73EFCCBB1A32E7C9CB3C263701D74B05093902DEB571C0CDA138A03155428EF686BFDF2EB6A91902122841C67EF222DD753DA6D0C62D38D0B4E6A99680820C51B72D0E596731';
wwv_flow_api.g_varchar2_table(30) := '756C023625C9C5CA21E414C49D692CE426E0C5C0988C577F919A901BE75D37019B04B85859F440AB1893172B6E29F14DC04B9192E9340DB464E3809BD3A425680385A420F397211C9371840BDD9C262D4176B1495282ACC764FCB171FCEB33D33F7B3267';
wwv_flow_api.g_varchar2_table(31) := 'C14DD3AD5EB73464CE8FE97871E58B900D067380CDD6CB6013235E94368C2450B4FB900DAE789803AC2B1A717946B67A34106DC91C93F346FE81BF7A23859936372D38BC1C83903BE07CA9703854B9F8ED6733444A021A728B99CED54C290109357BEA80';
wwv_flow_api.g_varchar2_table(32) := '30AA3C55B2E397C1DED0B805B36ECB0999CF57EF2554B5F06AB39016EBB4DE4B39666978F7BDEB85F2CEA63677E6D516E51914A071C0E69A5B7D4914502BA4D3823FD34DC80457C471D2C5CB6B0272633A861695D643E8C073D5F7F18E2AE59C30CF14F2';
wwv_flow_api.g_varchar2_table(33) := 'F22D640665CE47372CAC28C0F03DE5B29397F7F88A292E0B71BA61D9F2989D9214AE098C012FC58212587203E9868B792F9D1755F6BD1A791F40DE24D26AF865096270B1A2004F03E8E3A97639986CC57A01FE062CC04CBA45B998CF49CE294A02D7844B';
wwv_flow_api.g_varchar2_table(34) := 'ABFC41615AB627D2F2E5B6B5B2AE252B5D891669B5135244BE7128C9CDFC945C9A1993770A53EAF559B4F3384236077819FB302DFC2180F9DA5DBBE4C9B55B651AE72D76523E9C1E97BF7FFF0D7979EAA6ECB2D37215F74701EBEBABB7CA13AB36CAFAB6';
wwv_flow_api.g_varchar2_table(35) := '559249B6003EFEEE331480A10005284021C600F7E56B17E49B372ECA5AC4D392393B5DC6A6AAFA55F3650EF032A977F9635D599D6A93BBDB3A65125D6F2B0073FC546332128E035A1AE3F337EF79543EB9668B645369F4E2187BF161D0E0D415FAFBBB5B';
wwv_flow_api.g_varchar2_table(36) := '3BE5BDDC4DB975E35DE984FDA63132176266C7E6002B112DF79705CB2D48AE3023D300EC261C99E211FFCDE0F3212CF36FBB1F96CF756F57D63A857474C4525004BA6179C751F79535A3290E2D195D3CC1335DB932D5B1AD061F641CB0B6823A36FF3645';
wwv_flow_api.g_varchar2_table(37) := '73DCB5FDEE965DAEF74900CE2D80FFDDF635CA72391653093CB0AEFC64F403790B1F5A7D1269B3A956D9D8B65A7676AE4359098CDBDEEB2CEBDDB652F9A593DB34758951C60153F90CD66F89CD08260BA8BF7FAA0EB0C487336BA413F0F2E8AA9378990A';
wwv_flow_api.g_varchar2_table(38) := 'C7DC7323EFCB9F5FF9A10CE5275171D49CDD358E9BE13D3F9FBD07DEB72DEBE17CE1F5AF6ACA157C92E973D653C94E55D84CE9E6002F2FD545A4E149AC0B5EB30D117A57DEF1FDA951198203F6747A159C288274258FEEFA3A94E0EF46AFC8035652BA01';
wwv_flow_api.g_varchar2_table(39) := '98AFAE6CD87CD8A02CCD2DD418D4BA4568D510ED498CD31FBE3998E3A99A46A1A44FACDA207F7DD77639058FF9EDE294E48091DDF4BD89943C956895B59C3AD5F0C4A8643107D8A0D6D54538E86A2F4CDE94498CBD1C83E978713A740F3CE5AF6EDC27DF';
wwv_flow_api.g_varchar2_table(40) := '59BF4F7EBB6D8DFC1496FBFDE2B48C60CCE6C2883901D5A5558B166AAEFE91B560BF62F0945F9DBC2EE76EFD52395F2974C7F49267007415A656BFD5BD43FE66F353F2ED0DFBE52F3BEE955F20EE3D583C1D34EA6E649BB708627380236BC1DE7AF4BDB0';
wwv_flow_api.g_varchar2_table(41) := '607AC3DFFAF02772F6E615AC60DA9246374C6BCEC35AB9B0B1A625239FC222C95F6CFAA4BC048B7E04AB623F73E06DC718B239C054F188AA39FF1CD5289CA7B5B0E2F358B6FCAB2BA7E57B57CFCBB5E90965CD04CD29D50C40CF60AA944DA6E537BB1F94';
wwv_flow_api.g_varchar2_table(42) := 'C3F73F219F83F3F56E00F2220613B9687380D9B4A85A31EA45DDC35F58918D98FEDC04C42F5D3D2B5FFFF96BF2F2473F952B58ADE2984CD00CB4682E943C8479F09FAE7B44EE631EB7A0769F1AA2C3061F6216B0124FE3BE827250CB8DB0420B1F2F2016';
wwv_flow_api.g_varchar2_table(43) := '60E93573EAC39D26CFB912590D4B3E80CD8563B96BF2DCFBAFCBD77EFE7DF9EED5B7E4EAE428E6C79C12D9CACB26E8873AEF9167DABBE53CBA70065DBABAA8D797414369487D4DCB816009AC1D20383E72318232D98639ABB642A6A17BC4B175028B1C59';
wwv_flow_api.g_varchar2_table(44) := '8CB55C8BBE0968699C2791672FBAE227936DF2E6CCB87CF9EA907CE3BD1F2A6B661C7317E16871C36253EB2A5C631302CAC298A062A988087FC51230E18E40F8AF1626650CF0B85AF3A3420E4E5146EEF361D0A2F997CD382DFA085B830CF723BE0BDDF0';
wwv_flow_api.g_varchar2_table(45) := '2BF909EC05731F187BC348B313DB8B075B3AE55BB72ECBFFDCBCAC40EAA91441A70199C1FBC9B241F352A5D6F7CBDC4A567DEB59567A0E701F69E990CFC002FF2B775D5EC122C51E5CFFD1C73E2EEB30AF65D7CA654842FE002B55EF625E7B151B097BD1';
wwv_flow_api.g_varchar2_table(46) := 'D5FE59D77DF2CAF58BF2D2F855F93F28C86C70E52EEC0B6F6CED52AB5D7A41845A305E9C51C9D41F626984FD1AEC22620598B6C32E6718007BB119F07BEB7E43BE8471730280D7B676C826AC35832B003BCAEAC601F6CCD80772150AC16EB9055DEF1EAC';
wwv_flow_api.g_varchar2_table(47) := '5C6DCF76CB33E3D7E432163E7E3533A1163C3AB127FC30D69E7762CC25542E8270BB7114D6FFCEE40D05982B5CDC95AABB0D1B7C40AC0053CADE680B15877576A7B3B2011BF61C2B1938DEAA8D04804C02CE9B372ECBBFC252F7E0FC5DC4111AA7425DD8';
wwv_flow_api.g_varchar2_table(48) := '70D8BD7A833C0C6BE6353D683A57EC8A8B500E9691C675029FB32357E47BB95FCB6EC4D1B0F831287F567B6E88AC051BACD8DC56EB3BDE43E8E9B20B6677CC9FD930D0A9CAC03B26EE7300F34FBF7A4B3955DB706F14D31E76DB749AA8249E22C041431C';
wwv_flow_api.g_varchar2_table(49) := 'AD9E6BD30EE072EC4D635382FBCAA7AF5F927FC0C20857BCDA3155E2CE72DDE17A0DE1B79160D6821BD07A8A98A3E47574CBD76772B2B6A5BD6455B4C65F4EDD9237B11C79F4FA05198633B5C56E51BFC1DA9948CA99896BB2E5A30BB22DBB1656DC0665';
wwv_flow_api.g_varchar2_table(50) := '800F4EBAD00F569D8A32969F960F316E9F4119FF327249AE4131380F26DC3806B380EB2C0316CF9FC13E082B3C8D6E73FCF2FFCA967407BAD394B2B211403F3F3D2ADFC56733C011AEF77B0E912EAC3D0FCF8CCAAB1FFC5876C39BDE0E87AA1BBB45ADB0';
wwv_flow_api.g_varchar2_table(51) := '605A36BBF9098CD957B0D2358C69D31B70C07660DAB51E6573DCE5B31BA0BFC675C82C60E3D59B5B2005CD6E741A40FE190B1533B98F7087A2F7B4AB1B5DF7E35080561CA70360D86D13721A1DF85BB0ECFF04449D27989F8ED466A43B806E9A1B0D2C83';
wwv_flow_api.g_varchar2_table(52) := 'A53714AED7143C357C300BB84152202C7AC59F00049E7BF6E539609CCAF0D71753F38061DA76C0DB8ACF03380FE625427AE87A618056ABE1E2766C8359C00635EF7612A51E118E06C06B3E5AF9C37E1D16D235826360BC4EE3E577D5C63ECBD541C7EBEB';
wwv_flow_api.g_varchar2_table(53) := '861D0D3ED82C6054CC60DD96244FE2F299AAF48B3D3F18AFF3E9230B08C6AB021BF8558F67EB1EC94C3320A9A0B0CC147AE79452925DE9247CDBCD02860AD6430BC337331E259464573A095F6F7380FD4A1954BEF0AD8B5909F5909D39C0F5A85DCC0045';
wwv_flow_api.g_varchar2_table(54) := 'B1BAE60047B175CD3A95A67D358AE24879BEA61597CBA3962BCAD0A01CC359F0E04E6FE4C5DE39BCAB06ADC4D722B518E5D10E1665CA3038A8EF78D7557E8703DCFBB6D235D72E7A780D6A5E95ED5839C97D192A99B255BE8C6B6D6028C0BDBE055B4E02';
wwv_flow_api.g_varchar2_table(55) := 'D68BAD18FC8F9FA8B28ACD4F0D3250B2830C294B2553F2D5BD648D84C3AD64F57A4FCD4BF15252123F4B76B63F941F19E3AF5D6627C43C676047A3EFEBA38A087C05D3F27665BACAEB405695565FEB4E2D983E781E2CFB76F7994E97A5F3E87B95F974BC';
wwv_flow_api.g_varchar2_table(56) := '6EA74EC72343657A7D5D7E7420C344FEE6D8857C267D49E5F365ACCE6BF80A56BFFAEC50346CA8B28AB2EFB5179EC3BEDB8BA860D79CC6545FF29D97C3075D189DB8050BFEE3D79FF893EF282104645C8B50C201E6130315D87FFAC5C78B45396459D62A';
wwv_flow_api.g_varchar2_table(57) := 'FE3EC2EBFF2B4681928673599F71FE51DFD735526AC30720E8B8D2F96DF2062DA2949E273AE8BCFADA3F069FC15B95D7C1E4BA8EC17B0BD5379886E73A6F29BD7EC5936DE3172A23B614FFFD474F7EE575952D20DBCA621A7BCD8A348359091892E9FF03';
wwv_flow_api.g_varchar2_table(58) := '1CBBE6525E24301C0000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72351707250797182)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/js.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '89504E470D0A1A0A0000000D4948445200000078000000780806000000396436D2000000017352474200AECE1CE9000000097048597300000B1300000B1301009A9C18000001CB69545874584D4C3A636F6D2E61646F62652E786D7000000000003C783A';
wwv_flow_api.g_varchar2_table(2) := '786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D22584D5020436F726520352E342E30223E0A2020203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F';
wwv_flow_api.g_varchar2_table(3) := '313939392F30322F32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A4465736372697074696F6E207264663A61626F75743D22220A202020202020202020202020786D6C6E733A786D703D22687474703A2F2F6E732E61646F';
wwv_flow_api.g_varchar2_table(4) := '62652E636F6D2F7861702F312E302F220A202020202020202020202020786D6C6E733A746966663D22687474703A2F2F6E732E61646F62652E636F6D2F746966662F312E302F223E0A2020202020202020203C786D703A43726561746F72546F6F6C3E41';
wwv_flow_api.g_varchar2_table(5) := '646F626520496D61676552656164793C2F786D703A43726561746F72546F6F6C3E0A2020202020202020203C746966663A4F7269656E746174696F6E3E313C2F746966663A4F7269656E746174696F6E3E0A2020202020203C2F7264663A446573637269';
wwv_flow_api.g_varchar2_table(6) := '7074696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A292ECD3D00001960494441547801ED9D598C1D557AC74FDDBAF776B7DD9B5730DE8DCDD86E03B6593C10C12C114B226548A231C963A424330C8689A2288FC9F44B1E';
wwv_flow_api.g_varchar2_table(7) := 'F2121E1245488C2244C066E8044D26126232A31922CD12C0D8B4B18D59BC806D16EF6DB7DBDD7D97CAFF77EA9EEEEAD57DEFADBBB4FB1EA8AEAA53E77CE73BDFFF5BCE52B76C4C1C2908BC38C8D492467777903037403FC6CB30393EA3E87B84E27901F5';
wwv_flow_api.g_varchar2_table(8) := '1E797DE05E63BC6F1913740681C9274CC2F07FC5525E944BA40F7FF920686E4D9B73B72C30CF756FF73ED9B939F07B8220EFFA5331BEAB48B83CCB8B80FBF06B03DFF6FCC473A9D6A6CE2AF25F565339A96547CA98454DD99FA613B9279FB9A3F958F72F';
wwv_flow_api.g_varchar2_table(9) := '8364F7D74DEE4601B92C8077BE228D7FDCCB3DF2FAD565C6F83F4B7734750DF50D6644B444BB2A0BAFA22A8B472F2B2BEE68495C5BBE34DD961BCEBE990B927FFAEC36EFC48D04729940F458A1E6F3DE3AB9E5AF64AE648C9C3534EBFE90F17A26303644';
wwv_flow_api.g_varchar2_table(10) := 'E532D9FEE68EE40EDFCBBEF4546FB0B6FB1B5EB6FB0DE3DF0831B92C80BB76EEB4B1D7F73C3C01B1D8FEB5D75CD5F131C2A95C8F94D21BBC9C0DD26DC9FB837CF6A5EFBD3DB80E90BF7E03805C16C0877A7A00D1E47C0D5964C216600B39B9F59D46D90C';
wwv_flow_api.g_varchar2_table(11) := 'C4B83C8EB81FBA9CCD35B527EF4BA4FCDD4F1E0AD6BF219077DA67B377965016C0CE820B50CAE58D8AADBEE10D5D4B84C7C04B2418577943572CC83BBC4C76F777F70F6EE8F1BCDC6CB6E4B2008E086804E38979F599334E15AD27328259DC7A437D02B9';
wwv_flow_api.g_varchar2_table(12) := '2D794FD2F35F9AED961C33C0F509E6F5B90AE7F172C4E02E532EB86B818C257F7F7F602D7936BAEB390B7068B20EFA09317604E4746BF29E9C977DF9A9BD431B71D7B30DE4390BF018175D5889737017CE16E46162725B727B904CEC79EAC0EC0379CE02';
wwv_flow_api.g_varchar2_table(13) := '3CC682A75E831EB5E4B6E4D6200FC8C1ACB2E4390BB0B56067C6935B30133FD28825CB5D6F0D72D9979F3E146CB6EEBA87E9D504F75E7000F5718A196027B1FAE8DC75B91863C69394E6B90359A3EBE1FE6C2EDD9EBC33C8647FF4FDDE600BCBB43B0572';
wwv_flow_api.g_varchar2_table(14) := '50C720C70CF0F5243689106B9435634E470B222B6F588B21A9B6E4967C90DDF344EF9005F9F13A063966806B845609CD96E86B42770DC8ADC92D89C0AB7B90E72CC0A38659B47684032F46D7ADA92D7EE0BDFCF4C1E04EDCF5E33D3D09FBE240D1242B57';
wwv_flow_api.g_varchar2_table(15) := '61CE023CC6828B8FA109AD791193B34D6DA9AE7C36F3F213EF0E6FEB79FCF1DCA1CDC6AB27906306788CD82AA79671539E6A143D5D3BDA16556F7DAD5D03F246DF98DD4F5B903D81DC533720C70C70198E6F3A61D6E933F596354E5FBB501664BD41B47B';
wwv_flow_api.g_varchar2_table(16) := '57EFF0762CD9FCC0987AB0E498019EA5165CAA0269F7CC82EC8520A765C9DAB0D8F3E4FEE17BBA3D2F5F0F20C70CF0ECB1E05838E5058708C89A42C99293B7297777BD801C33C0A59A42F5EB8DF135C50FB24619B620CB57E3AE9D25B7A7D6273CEFA57A';
wwv_flow_api.g_varchar2_table(17) := '0079CE023C8A90AE4A1964450914DC8103194BD63C790396BC6BEFF08E5ABAEB390B70019310A6722C380AB4DCC208C81A5D2B26AF37DA85DAB52F735FAD409EB3008F71D1E55AB003B9A03563406EF5D7068960F7AE03B50179CE02EC30B1E7B82C3842';
wwv_flow_api.g_varchar2_table(18) := '74046416435A536B4CBE3620CF6D809D19C765C11180D985B2206B9ECC8A573A0479CFF7DEC93C60DDB5CA56639E1C33C04E62D19ED6F175C1A55684C302ED7120AF4EF81A78EDCB3CD8DDAD79B25277A01FBD5530C54CBC92128B570AD5E4740464065E';
wwv_flow_api.g_varchar2_table(19) := 'ADC9157AD5FEC5A77B65C902F9079A495712E498018E17844A52ABB6AFB1206B9EAC77BCB2E979FE4AFDB2F1250DBC1ED48F4282EE0A823C6701AEA6053B450564FD17C6E4F9A995266F763FD59BF926F3F04A813C67011E63C1636E1C1C153B87205FCD';
wwv_flow_api.g_varchar2_table(20) := '66E4AE976B00FFEF9504396680AB2BA9F820A8FA8B733890A446D702D9BF259F372FEEEACDFC6E252C3966806BE1F8CA8079541FED2FD02C25F2ECA13FFCD66AC607F5AE531ECA23B4ED56A305B9A935B94CBB502FECDA3FF89005593B513B5F79455BCC';
wwv_flow_api.g_varchar2_table(21) := 'E5A7980186FB5999709B00149EB9B63F85D5C58CCF33A813C6E0024D6E6CABA9709EECDF623CFFC5277B338F2241F694E39827C70C3092990D695411B5631FF8092FAFDD1FE3FB89BC97D0A650550FBDBAE77B7E76203FACADC6A5FAADF5F37F7D24B020';
wwv_flow_api.g_varchar2_table(22) := 'DBB97299AB6CE57F846536E03981471451EFDCE827A343D9C0BF70E1EAA031F97EBB7D4F595C2D966BFD29192EB93CA7C8284A24CFD6A3ACCB73F5C6E7E9B96B237ABEE0F5FBC9D44D99A1A17FFAC3D7BEFCE8C7BF7FD351DEBBD6771472514AC55CCF51';
wwv_flow_api.g_varchar2_table(23) := '804311F163C2A19C69FA6230F0CD407F90CFE7342DC5A98D5A7831C22CAFAC40F7829462712E91F03689D60A1D47BB769A20FC504669D4E730C0A19529E87A7EBA2515C862BD6BFDC2562B8816E4D2045A56ADBCBC4A3A6D72D9E1ACA76F499445AB5079';
wwv_flow_api.g_varchar2_table(24) := '0E038C049C2BCD075EAAC98A241814C87979C41A58B2DC8716B8F23EB6AC5994E5C77D26C3DE94F027E64156091CD4BC8A6449F0D56046207B5E73AB4C39E1E9336978F0AA1E1AEFA171612A98DEB8CF64B8A7333E37008E8A4A031E2CD96B69D36F0A25';
wwv_flow_api.g_varchar2_table(25) := '1A0640D54C15682E66802BC06135054C5BB506D9F5379608CC6F5F634DA31E2656B2D526562B90A3E28B69741433C0D546A282EDD50AE498BBD400783A81561BE40A44B806C0D301CCB36A821C75D1D7E36B86CF6306B8022A38C38E54B458B540AE80F8';
wwv_flow_api.g_varchar2_table(26) := '6206B8022A5851E48A205E0D902B20BE9801AE800A168141C58B4E00D9BE18195FB315105F4C8371D7C70AA8A0235D2FE702C8B013B0766D973563EA77944C7DCE83EB05850AF331C692F5E285EE634F31995ECC2E3AF66ED62F410B72BAB0AC09C831B8';
wwv_flow_api.g_varchar2_table(27) := 'EB0AE84903E07254680CC832B94A587239FCA96E03E0320518CE930B96EC9769C9D1185C2E5F85FA0D80E310A4B3E46676A1B0E412DD75C345C7814685683890D96AF4EBC75D372C384EBC1DC85872B9EEBA314D8A1399186915404ED48925372C38466C';
wwv_flow_api.g_varchar2_table(28) := '47480964934C9B10E412075E8D79F08838EBF3620CC8331C783546D1F589E5945C9502F294C44A7BD070D1A5C96DE6B546406E2F8CAEA7994235A64933976B5D95B420A71493670072CC8C372C3866814E496E0464374F9EC692A72452FC8306C0C5CBAC';
wwv_flow_api.g_varchar2_table(29) := 'F41A63DCB5FE65EAF12B5ED14156631E5CBA9C6B5A738C258F03391A831BD3A49AC2545EE3586E92988CBB8E80DCB0E0F2E45A3FB585E474960CA30D0BAE1FB84AE66402C8111FDD88C1258BB5BE2A46DCB567DD7501E48605D7174EA57383BB0E6332BF';
wwv_flow_api.g_varchar2_table(30) := '6AF4149BE37C3324263D29BD7B8D9A48A000B2F691BDA4065E39F9E7EC702CA269001C8B18E3203276E095CF34008E43AAF5478310CC6B3F2DE12725CA65B0B19255AE042B521F9433B150AE898B86FDC258714C27E4A48846D74DE5D48FB61B6DCBE547';
wwv_flow_api.g_varchar2_table(31) := 'F3A28C4CD6E64CF82DB55EB4ED72AEAB0A309DC565B4483208C709950EF0DDB1AC328674F06CBAD4A402491D4C235DA27EAE50DFE545CFAE28F5344EB589E57EF29565F4DE85BD1E56065F1D23CF25CAA49491D6D995E7195132A38C6859F25D9AAA1E7D';
wwv_flow_api.g_varchar2_table(32) := '649A3B553D573F8E735501065C04724CBDBBA633DF0B7289FCE592F222159A6E9F852A9FABFE17CC2C0AF539517FB1EA2E150DDAD1ED48E29A8E0252BFEA1D1382FAAC9D1530CF284F9B0BF57C990A36EB0CD0E4411BF0CFABCE291DD070F92B54B14DC7';
wwv_flow_api.g_varchar2_table(33) := '78855071DB3EF5FAF4F0131DAEAF28E12A3D689FA21E75E34C5505180B6D55C71E6909420B8CF444D9E69CC2CEC98C67B050043F5942F3BB9A03F3A03847D02E51FF8A047972D8B30247B8D0E080DE3515EE15FD55AAF78DD6C0DCD214984E9924800DE9';
wwv_flow_api.g_varchar2_table(34) := 'D94599E327839E79EB9A673DC9AD2A0728280E606F52F9FB950798B405DDCFD4D67931040DEEA3893258EA0AB98B7BE68F7ECC96FCB3E2E3D475FA19A555CEB558AE4EB2562041DEAECE7E677DD6B4A9E359DDE35A71B5E964608E5C48987F389AB482C1';
wwv_flow_api.g_varchar2_table(35) := '8D03A64E36511FEB5B940ACC13B7E6CCAAD6BCC9E4F4940285FA1FF525CC33AA8FA274A802E000EE1911D257AFCCD34BF366C7A2BC592980E78B4E5265103856052F97873C73F472C2FCE26CC2FC579F67D6EA79B30A7CACFA8F7504E6B155C01B265FFF';
wwv_flow_api.g_varchar2_table(36) := 'B8EC9B5FFAE6EF4FF8D622C915199B6089032FF39D9B73E6816539CBAB2F5AC3CAFBD171DFFCF69C67364906284F2553D500064834BA59425B3C2F301DE9409D0E01D677E6942F2D5F9837DBBF08CCAB12EE1614A0D07927B0B312CE4302E72B0BF266BE';
wwv_flow_api.g_varchar2_table(37) := '1422AB4FFF390569524FCE0F06B23AE517BE0A9C56C5D30267ADDAFA738173D792BC69D33564ED77CE0AF4B1404F7C753609FCB6BCE95A24E19FF2CDB39FFB462C59777A62409E456D2E94F718966235EB7AA3F8587F3A61CE653DD3A9FA2814BCA23403';
wwv_flow_api.g_varchar2_table(38) := 'BA5E219EBA4460A9FA3BACBEA6D5C7D3FD9EF958B416A8A048573CC14B75923A8CCBC35A0625F46B7251D72498411DFA20A8B92277375F02D9D69937175586CE232C5DDAB3B51D656C5D1058977855F5872468EA8FD2B11FACB3E501EDACDA592740FF66';
wwv_flow_api.g_varchar2_table(39) := '7DCE7C6D794E564BDBAAA703C5F025F0842C9133EDC013E0DDA410F2C7EB72E6AF56E4CC253D98A7B2BF1230472EEAEBB47A7E4D1E62406517C86D6F97C211D3A396A2EFE49933CABB4BDE0A85A0ACEDB3DA3D78C137FF2D809748219045A55394AFCAB6';
wwv_flow_api.g_varchar2_table(40) := 'A54E3BB0001A770588D191301ABEA15D6E34ED9B8B121056810B5371734585BB24D0F57AAECF390B207D6D50CF10A68AD93CF2490CBE88ABB8E5EFAEC999AD4B72262B60708F226DD32901F6D9D584B9A676162816AF165DBC4A5695509E1659E8EFC9EA';
wwv_flow_api.g_varchar2_table(41) := 'CF2A2EFFDB19312B5A1F28046C93174889067CB74A6136B5CB139D0F63B38A585EE9E8391D5DA24919EEA983221F9277D29B5996EF1B0B602BD6F08FFA6B13EEE392AC212797BA48E0E1AA9749EBEF567C7D5EF178918482D000F17381F39884B958D6C5';
wwv_flow_api.g_varchar2_table(42) := '272411569F8058A27A94194DB270E5103777DD24972F4072022DA3FA4D0521FFF233DFBCFA79C20E7444C6C6E97B65897FB23A6B367486DC61E9C4E98765F97B2F7BE60D0DBEDED5F92101BEB4251FBA6929E41AB9F43BA535FD2234AF00BC2285592FD3';
wwv_flow_api.g_varchar2_table(43) := '592F7E9352BA61B59F92A738732D61DE148D6528B713C228E315B942C6D549133A14C64F04796928B440063AEDB2A2DB35A00135629A6466633183A53BE4BEB1AC40E683955D56BDA404174D78878BA2B34EE0DCBF3467CB036EE83102F386C07D4A839C';
wwv_flow_api.g_varchar2_table(44) := 'F70414EEAB5907D6F88FE73DF3AF1F27CDA92B2118B870DCF58AB6C07C6D61A8440704F2A77A8EC25187E326C5D76D3A4E0A608C15819E537BDBA488372BDF71C7F9A8AC77BF06724CAD5CBEB22B9AAA07B084124D7CA91E41E1A64E292661BD082C298E';
wwv_flow_api.g_varchar2_table(45) := 'D0FCBBB5147B41424BEB1E77BD5DB16CADF2A903FA6725EC21814CF950586103B8E7FD2A7F9F80592EAB7474B1A0535712E685D31AF5AACC6D72CBF35597392F73D23F12D23F1478BF953BC6E2A0CB202FAD7A1B3BF2668DB4E1B8BCC2A14B611C4661F0';
wwv_flow_api.g_varchar2_table(46) := '0CEDA2B359562C2F6DF940C18E09E03BC46B3B5E4965284B1CDEAFBA28147D5091AA24355DA514A230D258E868C3CC0F3535B9AC7928D69853CF6F9E9F37DBE4A64FEB3A29B19DD07987AC7AA1048612609147640D9C9D353998794E5A2D57DF2250F44F';
wwv_flow_api.g_varchar2_table(47) := 'D684236DE51D91800FAB1D0638CC8B19D54B17CC80AEA9B649D2E8559CC5A3301A27137A8B648D6BE4591056AF5CEC79593F0A6315406EFA5629D36D6A0B9AE4B100C25802E54081191B7C29257E5B0AB654CF1C8F2257F104CF3126F566C6496AAC84C5';
wwv_flow_api.g_varchar2_table(48) := '7DA4CE9FEC4FD87969C65A45E8A67165FD7293CB044897DC33D314D215C5EDB70516D6323EE1D671EF4B65F1CC5589759463F46BA73A7A4C110ED7799E8BA45D453B2105B828378A8BE61066A65DEE7E89009CAFFBC302F7B840E61940E964C70DDBD4DE';
wwv_flow_api.g_varchar2_table(49) := '051566856EABAE974BC17846A2AD0FA538EF8BF63C00B6B9D5F9E3FA18536BAE4B3323474771856724DDF72F69054A0282025679AB2C00B7FC6B3DFBAA62D96A5989A37E4ACAF09BABA11B1DDF524EA53A94D92E40501E00020C2C09C5204DD669C0626A';
wwv_flow_api.g_varchar2_table(50) := '75518A601750C2A24243F35F29186300165FFA4470BC9B66BAB459E1E0AA687C2197B04DBC2E10EF8407FAC27861BFFA37AFD0363C552B4DD6D732DA06B299A6B0ACB5145579471A7E4196635D9FAC98C1CB9D12DA15C5BDBB15033B9D7B96D00E4B58C4';
wwv_flow_api.g_varchar2_table(51) := '59843731C9729539D6BAC3B6A2DC4D760D39F2A3CFB8037C3C010B275871AF62F519791D78254C30F0C325335FBEAC721B157F59B841A9F0229F694AF68E947261CCD29ED8F78939313789888A4BC462D6A77F258B3CA918C587D6B302AF55310F41B185';
wwv_flow_api.g_varchar2_table(52) := '739BE22F02837A9FE2E35B72CFEB0B4D8D8F6774489F273383123CA0508C011D80B7CAAA49CA1EF106DC530645C3BD7708108073897CE6CACCC3519C76DD33028FBA69146D959471B55CF95AB5C1D489F6E08D83D87F54DEA345CC61BDA3D45D2B953B23';
wwv_flow_api.g_varchar2_table(53) := '8FEA2475389A14C5741BAE3C11970EC85271D34C4D10188C11C7FE56F3D29B35C841D0FCCB28C4EAFF93F52C9E8273DC328B23E7E40D985F43CB5A9F1464B5BC42C14B5B569CA0790EF64CAFD648A13A358277E050BF4FAB6CEC600130BC9E57B983F238';
wwv_flow_api.g_varchar2_table(54) := 'ACA01162184D2F11ED0D2D1AEDEBCC5C3DAFBE01F265B9E77D2A8B75531F807559B5348598AAD6BE6D0821927A359A3EC708D5BA37ADEFCA2D3FA05528AC9958C8DAF5E18B5AC4D099E9CDC4140A151361EAC562880318616FD4406D9D26ABC4518042E0';
wwv_flow_api.g_varchar2_table(55) := '9069D2358A7150F95B150E585E4439502AD2970309F3A980C24593D7A1E38073D3E295F93B6BE39B64B9D49F276D61F4CE3228E38577E59D3AA1A5C32995255C853F750130B1EA7649BB57A09CD008154130E0B28B1E5AAC672ECC3FE5C8E8166B58A57B';
wwv_flow_api.g_varchar2_table(56) := '809B4C58D05A275AFB99CE68AE4C0C0414064EAB34F8F933AD4CFD5AC01FD588564D581A4C6FFEF39A317FA9E7BFA3D52FA63780867562A5BD522ACAA054B87162E941F1724C6DC003072C6E5028D9288FC3350925C12B7D2AEBB7EE9982554E8E972A37';
wwv_flow_api.g_varchar2_table(57) := '3BB6394041686CA81F2EB83E00C4EA16CA65DA78A62A2764354C5316C0F5A4C20AE7A66CA8FF46E0EE3B97B06BCB5827F353E87C5300BFBC366736C94AD9CE3BAD3685A1F9BBC579B34BDB98EC263155833C6BE31F8B9F5F28861212E009F7CF028973D3';
wwv_flow_api.g_varchar2_table(58) := '2C60A008D421F6AED0FC9DFE30A767BCC0E206A36F7850735575CF6ACE861ECE354A883114260C2C9610F6C92A1E9225AFD1A814A1111F112CF3D8F7B49B7359520260E1326582EA6A81BCE70BDFDC268BDAB22867720282CD8616E53FBA3267B6C8339C';
wwv_flow_api.g_varchar2_table(59) := '533BB8D21629D14A0143EC65B301EF314F032656CB7EA26DC3930ADCAC64A12424B16316E9CF018D8E59C0B8556E194B676381227670A7E79F6AD08857C2A5937856B8B4F7D5F82351552FD1393AC9000621D86544DD93CFAA122B4C7B25D4638AC55801';
wwv_flow_api.g_varchar2_table(60) := '89334B7DE7948FDBD53F5B353258B1032195A1A85B92841A56D62E5A9FC80D3F7FCC37C76485FAC7EB343A667D19AAC6AC95B5DDA3CDF81DB7E4CC9D8B73DA49428942DED864B8A481D5ABC793E6C772B12B89A9AAC34102E845A2C5683AE435848D3EC1';
wwv_flow_api.g_varchar2_table(61) := '13772C77329DC34360F1F4232C654954ED8F9A8E33A91753253D42002C01DA8503B93FA63EC43BEBFA54AF45D7B8CD835A861C94C5B64AD04D2AC3C1B4E48004CAEA961336B1195A6C0152862D39E0860B6225AFE7FCAFACEC5F3E4C9ABD677C2B642C13';
wwv_flow_api.g_varchar2_table(62) := '1EF00E6C21DA6D449DA9C37C9601DE7159DE0B1F25CD0FCF24CC72B58190D00B00E250488D8CA6E195AD43FA12BA750685D63D4B519D7BA67E2D924410679A5A471120AB410312E667725BAD5A36A234A366BB4FAB6BDEC4582F21ED53ACFDAAB60B59BD';
wwv_flow_api.g_varchar2_table(63) := '622181BA7B750F68AC36B11D07E36734D039A5112A1BF5CDCA38235A4C4F8877D4018835729BAC7A1D17C87FA0387B975ED959A6B56E5E1942B14894ED971B3EABEDBCF715065ED72B3B4CC5568B263A039D42515D85092503FCF7A44087E15521859D31';
wwv_flow_api.g_varchar2_table(64) := 'FE6349F5C079DF7C20AF4338A16CAD52CC0023AAC9131ADCA9CE1E53A7FF59C266C04302B4B30208CB641D9777A9CEEBFE59B9D68E027794F95C2E933569DC2F2093F69C4A98F9DAD7C53300169B065813734E5CA2FE1FB16476A49E51D9751A786DD600';
wwv_flow_api.g_varchar2_table(65) := '6BB9A6606C4678B266E6DE6745FF8846D2EF4B69B03A5EBAA3FE64E0D23C7C2C103FBCAE03AFED7AC10B3ED0049E9F97C2A84B96575C3A79B54831033C7D170095E9C6BBB20E044752E8D3EAD1A8359147B94F25F07E8D42110C8262943D7E247A54605C';
wwv_flow_api.g_varchar2_table(66) := '153DCAA340008BA2302D2AC85AB9617CE7ED10B605798DF5E7F210033AA00B7DEA5A3E7443BCC5D3A054581ECFA74BD038215EF927A69D470068FAC45C1B3E6A996206787A71D05940BA59ADBA92E421CCF10940164632271338EE8FB73EA80E3D007123';
wwv_flow_api.g_varchar2_table(67) := 'DD4855FB0C8B038C85D0D50108D4737501071A583E033EAE396692B064F88826E8A038B54E31038CB8A64F9440D8D1349920C7833E99C0F1028C5A5D9A8C4EF4194527038F7CE7D2293F1D1D9E8F4FE37975CF8BA5E3EAC5798E19E099756926A5665206';
wwv_flow_api.g_varchar2_table(68) := '41CCB49C139A2B1FD10BF7A8685AAEA2A3E9EEEBE98CD78A314D26B618C93748152D819801AE675D2E5A363744859801BE2164724375A201F00D05E7C4CE34009E28931B2A2766801B83ACF2B5235E199605F0A19E9EE8A82ADC592FBF87739B825B862B';
wwv_flow_api.g_varchar2_table(69) := '48619C8C8B964D590077EDDC69D5CDCFC195A6916EAFAC68361A15AC049062418605991A27E3522554D64287D3AE9C7E2C9460D51EE6D8AD1BDDC32F95AFB9590FD9854B73013245084EC6A50AA42C808DD969DBD5CB65C7B4D2FB41AA2DD535D4C73B86';
wwv_flow_api.g_varchar2_table(70) := '8D548A04B45B9A4FB7A5FCE1BEFC078944B3644A0A651C5E17FFB73C2C78E118CB557AF8B5816F7B7EE2B9546B5367F16C346A380964AE0CF6055EF017FFF3C8BCFFB0791119BB32C59CCB039896220C3CF2FAC0BD0AC5DF5266A760D72FB5CB0AF1C5F4';
wwv_flow_api.g_varchar2_table(71) := '635697CDEBC5308D62242CEF92363F7FF2D347D36FD90E45645BDB0EC24823C52B819864FAFFC8629CCDF62C637B0000000049454E44AE426082';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(72352098809797184)
,p_plugin_id=>wwv_flow_api.id(136310961796859786)
,p_file_name=>'img/mov.png'
,p_mime_type=>'image/png'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
