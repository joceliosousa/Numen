CLASS lhc_matprograma DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setControlFields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MatPrograma~setControlFields.

ENDCLASS.

CLASS lhc_matprograma IMPLEMENTATION.

  METHOD setControlFields.

    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_time) = cl_abap_context_info=>get_system_time( ).

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MatPrograma
        FIELDS ( Dataincl Horaincl )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mat_programa).

    DATA lt_update TYPE TABLE FOR UPDATE zr_mat_rme\\MatPrograma.

    DATA(lv_status) = 'A'.
    LOOP AT lt_mat_programa INTO DATA(ls_mat_programa).

      APPEND VALUE #(
        %tky       = ls_mat_programa-%tky
        Dataincl   = lv_date
        Horaincl   = lv_time
        Dataalt    = lv_date
        Horaalt    = lv_time
        Status     = lv_status
        StatusText = SWITCH #( lv_status
                               WHEN 'A' THEN 'ADD'
                               WHEN 'U' THEN 'UPD'
                               WHEN 'D' THEN 'DEL'
                               ELSE ' ' )
      ) TO lt_update.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
        ENTITY MatPrograma
          UPDATE FIELDS ( Dataincl Horaincl Dataalt Horaalt Status StatusText )
          WITH lt_update
        REPORTED DATA(lt_reported).
    ENDIF.

  ENDMETHOD.

ENDCLASS.


CLASS lsc_zr_mat_rme DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zr_mat_rme IMPLEMENTATION.

  METHOD save_modified.

    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_time) = cl_abap_context_info=>get_system_time( ).
    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    LOOP AT update-materialmre ASSIGNING FIELD-SYMBOL(<fs_upd>).
      UPDATE ztdp_matrmema SET useralt = @lv_user,
                               dataalt = @lv_date,
                               horaalt = @lv_time
        WHERE matnr = @<fs_upd>-Matnr
          AND omrme = @<fs_upd>-Omrme.
    ENDLOOP.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
        ENTITY MaterialMRE
          ALL FIELDS
          WITH CORRESPONDING #( update-materialmre )
        RESULT DATA(lt_materialmre).

    DATA:
      lt_in_inst_tab TYPE cl_abap_parallel=>t_in_inst_tab,
      lt_messages    TYPE flog_t_message.

    DATA: lv_omrme    TYPE matnr,
          lv_language TYPE spras.

    LOOP AT create-materialmre ASSIGNING FIELD-SYMBOL(<fs_materialmre>).

      lv_omrme = <fs_materialmre>-Omrme.
      lv_language = sy-langu.

      DATA(lv_manper) = <fs_materialmre>-manpertext.
      DATA(lv_manpre) = <fs_materialmre>-manpretext.
      DATA(lv_manret) = <fs_materialmre>-manrettext.
      DATA(lv_mannot) = <fs_materialmre>-mannottext.
      lt_messages = NEW zcl_mat_rme_save( iv_material = CONV string( lv_omrme )
                                          iv_manper   = lv_manper
                                          iv_manpre   = lv_manpre
                                          iv_manret   = lv_manret
                                          iv_mannot   = lv_mannot )->save_text( ).

      DATA(lv_cod_ghs) = COND #( WHEN <fs_materialmre>-%control-CodGHS = cl_abap_behv=>flag_changed
                                THEN <fs_materialmre>-CodGHS
                                ELSE <fs_materialmre>-CodGHS ).
      DELETE FROM ztdp_mat_cl_ghs WHERE matnr = @<fs_materialmre>-Matnr AND omrme = @<fs_materialmre>-Omrme.
      INSERT ztdp_mat_cl_ghs FROM TABLE @( VALUE #(
        ( matnr   = <fs_materialmre>-Matnr
          omrme   = <fs_materialmre>-Omrme
          cod_ghs = lv_cod_ghs ) ) ).

      DELETE FROM ztdp_matrmeaplma WHERE matnr         = @<fs_materialmre>-Matnr
                                     AND omrme         = @<fs_materialmre>-Omrme
                                     AND cod_proj_aenv = @<fs_materialmre>-codprojaenv.
      INSERT ztdp_matrmeaplma FROM TABLE @( VALUE #(
        ( matnr         = <fs_materialmre>-Matnr
          omrme         = <fs_materialmre>-Omrme
          cod_proj_aenv = <fs_materialmre>-codprojaenv
          Doctype       = <fs_materialmre>-Doctype
          Docnro        = <fs_materialmre>-Docnro
          userincl      = lv_user
          dataincl      = lv_date
          horaincl      = lv_time
          useralt       = lv_user
          dataalt       = lv_date
          horaalt       = lv_time
          status        = 'A'
        ) ) ).

      IF <fs_materialmre>-%control-Lifnr = cl_abap_behv=>flag_changed.
        DATA(ls_mat_rme) = VALUE zcl_mat_rme_std=>ty_mat_rme( tabela        = 'FORNECEDOR'
                                                              matnr         = <fs_materialmre>-Matnr
                                                              omrme         = <fs_materialmre>-Omrme
                                                              lifnr         = <fs_materialmre>-Lifnr
                                                              cod_proj_aenv = <fs_materialmre>-CodProjAenv
                                                              cod_sit_mat   = <fs_materialmre>-CodSitMat
                                                            ).

        lt_messages = NEW zcl_mat_rme_std( is_mat_rme = ls_mat_rme )->run( ).

      ENDIF.

      LOOP AT lt_messages INTO DATA(ls_message)
        WHERE msgty = 'E' OR msgty = 'A'.

        APPEND VALUE #(
          %key        = <fs_materialmre>-%key
          %state_area = 'SAVE_MODIFIED'
          %msg        = new_message( id       = ls_message-msgid
                                     number   = ls_message-msgno
                                     severity = if_abap_behv_message=>severity-error
                                     v1       = ls_message-msgv1
                                     v2       = ls_message-msgv2
                                     v3       = ls_message-msgv3
                                     v4       = ls_message-msgv4 )
        ) TO reported-materialmre.
      ENDLOOP.

    ENDLOOP.

    LOOP AT update-materialmre ASSIGNING <fs_materialmre>.

      lv_omrme = <fs_materialmre>-Omrme.
      lv_language = sy-langu.

      lt_messages = NEW zcl_mat_rme_save( iv_material = CONV string( lv_omrme )
                                          iv_manper   = lt_materialmre[ KEY entity Matnr = <fs_materialmre>-Matnr omrme = lv_omrme ]-manpertext
                                          iv_manpre   = lt_materialmre[ KEY entity Matnr = <fs_materialmre>-Matnr omrme = lv_omrme ]-manpretext
                                          iv_manret   = lt_materialmre[ KEY entity Matnr = <fs_materialmre>-Matnr omrme = lv_omrme ]-manrettext
                                          iv_mannot   = lt_materialmre[ KEY entity Matnr = <fs_materialmre>-Matnr omrme = lv_omrme ]-mannottext )->save_text( ).

      IF <fs_materialmre>-%control-CodGHS = cl_abap_behv=>flag_changed.

        DATA(ls_materialmre_ghs) = lt_materialmre[
          KEY entity Matnr = <fs_materialmre>-Matnr
                     omrme = <fs_materialmre>-Omrme
        ].
        lv_cod_ghs = COND #( WHEN <fs_materialmre>-%control-CodGHS = cl_abap_behv=>flag_changed
                                  THEN <fs_materialmre>-CodGHS
                                  ELSE ls_materialmre_ghs-CodGHS ).
        DELETE FROM ztdp_mat_cl_ghs WHERE matnr = @<fs_materialmre>-Matnr AND omrme = @<fs_materialmre>-Omrme.
        INSERT ztdp_mat_cl_ghs FROM TABLE @( VALUE #(
          ( matnr   = <fs_materialmre>-Matnr
            omrme   = <fs_materialmre>-Omrme
            cod_ghs = lv_cod_ghs ) ) ).
      ENDIF.

      IF <fs_materialmre>-%control-Lifnr = cl_abap_behv=>flag_changed.
        ls_mat_rme = VALUE zcl_mat_rme_std=>ty_mat_rme( tabela        = 'FORNECEDOR'
                                                        matnr         = <fs_materialmre>-Matnr
                                                        omrme         = <fs_materialmre>-Omrme
                                                        lifnr         = <fs_materialmre>-Lifnr
                                                        cod_proj_aenv = <fs_materialmre>-CodProjAenv
                                                        cod_sit_mat   = <fs_materialmre>-CodSitMat
                                                      ).

        lt_messages = NEW zcl_mat_rme_std( is_mat_rme = ls_mat_rme )->run( ).

      ENDIF.

      LOOP AT lt_messages INTO ls_message
        WHERE msgty = 'E' OR msgty = 'A'.

        APPEND VALUE #(
          %key        = <fs_materialmre>-%key
          %state_area = 'SAVE_MODIFIED'
          %msg        = new_message( id       = ls_message-msgid
                                     number   = ls_message-msgno
                                     severity = if_abap_behv_message=>severity-error
                                     v1       = ls_message-msgv1
                                     v2       = ls_message-msgv2
                                     v3       = ls_message-msgv3
                                     v4       = ls_message-msgv4 )
        ) TO reported-materialmre.
      ENDLOOP.

    ENDLOOP.

    LOOP AT delete-materialmre ASSIGNING FIELD-SYMBOL(<fs_materialmre_del>).

      SELECT SINGLE @abap_true
        FROM zi_material_classe_ghs
        WHERE Material = @<fs_materialmre_del>-Matnr
          AND Omrme = @<fs_materialmre_del>-Omrme
        INTO @DATA(lv_ghs_del_exists).
      IF lv_ghs_del_exists = abap_true.
        DELETE FROM ztdp_mat_cl_ghs WHERE matnr         = @<fs_materialmre_del>-Matnr
                                      AND omrme         = @<fs_materialmre_del>-Omrme.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_materialmre DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS c_900000 TYPE c LENGTH 10 VALUE '0003000000'.

    METHODS validateMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR MaterialMRE~validateMandatoryFields.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR MaterialMRE RESULT result.
    METHODS Edit FOR MODIFY
      IMPORTING keys FOR ACTION MaterialMRE~Edit.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR MaterialMRE RESULT result.
    METHODS detAlteraCriticidade FOR DETERMINE ON MODIFY
      IMPORTING keys FOR materialmre~detAlteraCriticidade.
    METHODS detUnidadeMedida FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MaterialMRE~detUnidadeMedida.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE MaterialMRE.
    METHODS earlynumbering_cba_MatCas FOR NUMBERING
      IMPORTING entities FOR CREATE MaterialMRE\_MatCas.
    METHODS earlynumbering_cba_MatForn FOR NUMBERING
      IMPORTING entities FOR CREATE MaterialMRE\_MatFornecedor.
    METHODS earlynumbering_cba_MatParc FOR NUMBERING
      IMPORTING entities FOR CREATE MaterialMRE\_MatParceiro.
    METHODS setDefaultValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MaterialMRE~setDefaultValues.
    METHODS setControlFields FOR DETERMINE ON SAVE
      IMPORTING keys FOR MaterialMRE~setControlFields.
    METHODS copy FOR MODIFY
      IMPORTING keys FOR ACTION MaterialMRE~copy.
    METHODS detGrupoEmbalagem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MaterialMRE~detGrupoEmbalagem.

ENDCLASS.

CLASS lhc_materialmre IMPLEMENTATION.

  METHOD validateMandatoryFields.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(materiais).

    LOOP AT materiais INTO DATA(material).

      APPEND VALUE #( %tky        = material-%tky
                      %state_area = 'VALIDATE_MANDATORY_FIELDS' ) TO reported-materialmre.

      IF material-CodSitMat IS INITIAL OR
         material-Dscexpen IS INITIAL OR
         material-Dscexppt IS INITIAL OR
         material-Emnfr IS INITIAL OR
         material-Lifnr IS INITIAL OR
         material-Ferth IS INITIAL OR
         material-NumCapRme IS INITIAL OR
         material-NumSucpRme IS INITIAL OR
         material-NumScaoRme IS INITIAL OR
         material-Ausme IS INITIAL OR
         material-VlrPesCalc IS INITIAL OR
         material-OrigemMaterial IS INITIAL OR
         material-IndRastb IS INITIAL OR
*         material-Matctrl IS INITIAL OR
         material-CodOnu IS INITIAL OR
         material-Raube IS INITIAL OR
         material-CodGHS IS INITIAL.

        APPEND VALUE #( %tky = material-%tky ) TO failed-materialmre.

        APPEND VALUE #(
            %tky                    = material-%tky
            %state_area             = 'VALIDATE_MANDATORY_FIELDS'
            %msg                    = new_message( id       = 'ZDP_MAT'
                                                   number   = '004'
                                                   severity = if_abap_behv_message=>severity-error )
            %element-CodSitMat      = COND #( WHEN material-CodSitMat IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-Dscexpen       = COND #( WHEN material-Dscexpen IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-Dscexppt       = COND #( WHEN material-Dscexppt IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-Emnfr          = COND #( WHEN material-Emnfr IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-Lifnr          = COND #( WHEN material-Lifnr IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-Ferth          = COND #( WHEN material-Ferth IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-NumCapRme      = COND #( WHEN material-NumCapRme IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-NumSucpRme     = COND #( WHEN material-NumSucpRme IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-NumScaoRme     = COND #( WHEN material-NumScaoRme IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-Ausme          = COND #( WHEN material-Ausme IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-VlrPesCalc     = COND #( WHEN material-VlrPesCalc IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-OrigemMaterial = COND #( WHEN material-OrigemMaterial IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-IndRastb       = COND #( WHEN material-IndRastb IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
*            %element-Matctrl        = COND #( WHEN material-Matctrl IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-CodOnu         = COND #( WHEN material-CodOnu IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-Raube          = COND #( WHEN material-Raube IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
            %element-CodGHS         = COND #( WHEN material-CodGHS IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
        ) TO reported-materialmre.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA:
      lt_in_inst_tab TYPE cl_abap_parallel=>t_in_inst_tab,
      lt_mat         TYPE TABLE OF matnr,
      lt_messages    TYPE flog_t_message.

    DATA: lv_matnr      TYPE matnr,
          lv_matnrc(18) TYPE c.

    DATA: lv_omrme_num        TYPE cl_numberrange_runtime=>nr_number,
          lv_omrme_returncode TYPE cl_numberrange_runtime=>nr_returncode,
          lv_omrme_qty        TYPE cl_numberrange_runtime=>nr_returned_quantity.

    CONSTANTS c_omrme TYPE zomrme VALUE '000000'.

    LOOP AT entities INTO DATA(wa_entity) .

      IF wa_entity-matnr IS INITIAL.

        INSERT NEW zcl_mat_parallel_get_next_num( ) INTO TABLE lt_in_inst_tab.

        NEW cl_abap_parallel( p_num_tasks = 1 )->run_inst(
          EXPORTING
            p_in_tab  = lt_in_inst_tab
          IMPORTING
            p_out_tab = DATA(lt_out_ta) ).

        CLEAR lt_messages[].

        LOOP AT lt_out_ta ASSIGNING FIELD-SYMBOL(<fs_out_ta>).
          INSERT LINES OF CAST zcl_mat_parallel_get_next_num( <fs_out_ta>-inst )->get_messages( )
            INTO TABLE lt_messages.
        ENDLOOP.

        LOOP AT lt_messages INTO DATA(ls_message).

          IF ls_message-msgty = 'S' AND
             ls_message-msgid = 'ZDP_MAT' AND
             ls_message-msgno = '003'.

            lv_matnrc = |{ ls_message-msgv1 ALPHA = IN }|.

            lv_matnrc = |{ ls_message-msgv1 ALPHA = OUT }|.

            wa_entity-matnr = |RME-{ lv_matnrc }|.

            CLEAR: lv_omrme_num, lv_omrme_returncode, lv_omrme_qty.

            wa_entity-Omrme = c_omrme.

          ENDIF.

          IF ls_message-msgty = 'E' OR
             ls_message-msgty = 'A'.
            APPEND VALUE #(
              %cid        = wa_entity-%cid
              %state_area = 'EARLYNUMBERINGCREATE'
              %msg        = new_message( id       = ls_message-msgid
                                         number   = ls_message-msgno
                                         severity = if_abap_behv_message=>severity-error
                                         v1       = ls_message-msgv1
                                         v2       = ls_message-msgv2
                                         v3       = ls_message-msgv3
                                         v4       = ls_message-msgv4 )
            ) TO reported-materialmre.
          ENDIF.
        ENDLOOP.

      ENDIF.

      APPEND VALUE #( %cid      = wa_entity-%cid
                      %key      = wa_entity-%key
                      %is_draft = wa_entity-%is_draft )
        TO mapped-materialmre.

    ENDLOOP.

  ENDMETHOD.

  METHOD Edit.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        FIELDS ( StatusCRUD )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_draft_data).

    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        UPDATE FIELDS ( StatusCRUD )
        WITH VALUE #( FOR draft IN lt_draft_data ( %tky       = draft-%tky
                                                   %is_draft  = if_abap_behv=>mk-on
                                                   StatusCRUD = 'EDIT'
                      ) )
    REPORTED reported
    FAILED failed.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        FIELDS ( CodSitMat Matnr )
        WITH CORRESPONDING #( keys )
      RESULT DATA(MateriaisRME).

    LOOP AT MateriaisRME ASSIGNING FIELD-SYMBOL(<material_rme>).

      APPEND VALUE #(
        %tky                       = <material_rme>-%tky
        %features-%field-CodSitMat = if_abap_behv=>fc-f-unrestricted
      ) TO result.

      IF <material_rme>-CodSitMat IS NOT INITIAL.
        IF <material_rme>-CodSitMat = 'L'.
          APPEND VALUE #(
            %tky        = <material_rme>-%tky
            %state_area = 'DEFAULT_MESSAGE'
            %msg        = new_message( id       = 'ZDP_MAT'
                                       number   = '104'
                                       severity = if_abap_behv_message=>severity-success
                                       v1       = <material_rme>-Matnr )
          ) TO reported-materialmre.
        ELSE.
          APPEND VALUE #(
            %tky        = <material_rme>-%tky
            %state_area = 'DEFAULT_MESSAGE'
            %msg        = new_message( id       = 'ZDP_MAT'
                                       number   = '105'
                                       severity = if_abap_behv_message=>severity-information
                                       v1       = <material_rme>-Matnr )
          ) TO reported-materialmre.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD detAlteraCriticidade.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        FIELDS ( CodSitMat )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mat)
      FAILED DATA(lt_failed).

    DATA lt_update TYPE TABLE FOR UPDATE zr_mat_rme\\MaterialMRE.

    lt_update = VALUE #(
      FOR ls_mat IN lt_mat (
        %tky                       = ls_mat-%tky
        SitMatCriticality          = SWITCH #( ls_mat-CodSitMat
                                               WHEN 'K' THEN '2'
                                               WHEN 'D' THEN '1'
                                               WHEN 'L' THEN '3'
                                               ELSE '2' )
        %control-SitMatCriticality = if_abap_behv=>mk-on
      )
    ).

    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        UPDATE FIELDS ( SitMatCriticality )
        WITH lt_update
      REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD detUnidadeMedida.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
          FIELDS ( Ausme )
          WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mat)
      FAILED DATA(lt_failed).

    LOOP AT lt_mat ASSIGNING FIELD-SYMBOL(<ls_mat>).

      CLEAR <ls_mat>-Meins.
      SELECT SINGLE FROM zi_tdp_umprojbas
          FIELDS meins
          WHERE Ausme = @<ls_mat>-Ausme
          INTO @<ls_mat>-Meins.

    ENDLOOP.

    DATA lt_update TYPE TABLE FOR UPDATE zr_mat_rme\\MaterialMRE.
    lt_update = VALUE #(
      FOR ls_mat IN lt_mat (
      %tky           = ls_mat-%tky
      Meins          = ls_mat-Meins
      %control-Meins = if_abap_behv=>mk-on
      )
    ).

    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        UPDATE FIELDS ( Meins )
        WITH lt_update
      REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD setDefaultValues.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        FIELDS ( CompanyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mat).

    DATA lt_update TYPE TABLE FOR UPDATE zr_mat_rme\\MaterialMRE.

    lt_update = VALUE #(
      FOR ls_mat IN lt_mat WHERE ( CompanyCode IS INITIAL ) (
        %tky                 = ls_mat-%tky
        CompanyCode          = '1710'
        %control-CompanyCode = if_abap_behv=>mk-on
      )
    ).

    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        UPDATE FIELDS ( CompanyCode )
        WITH lt_update
      REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD setControlFields.
    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_time) = cl_abap_context_info=>get_system_time( ).
    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        UPDATE FIELDS ( Createdby Datainc Horaincl UserAlt Dataalt Horaalt )
        WITH VALUE #( FOR key IN keys (
                      %tky     = key-%tky
                      Datainc  = lv_date
                      Horaincl = lv_time
                      Dataalt  = lv_date
                      Horaalt  = lv_time
                      ) )
      REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD copy.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orig).

    DATA lt_create TYPE TABLE FOR CREATE zr_mat_rme\\MaterialMRE.
    DATA: lt_root_create        TYPE TABLE FOR CREATE zr_mat_rme\\MaterialMRE.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(roots)
        FAILED DATA(read_failed).

    lt_root_create = CORRESPONDING #( roots CHANGING CONTROL EXCEPT CompanyCode ).

    LOOP AT lt_root_create ASSIGNING FIELD-SYMBOL(<fs_root_c>).
      <fs_root_c>-%cid = keys[ KEY entity %key = <fs_root_c>-%key ]-%cid.
      <fs_root_c>-%control-Matnr = if_abap_behv=>mk-off.
      <fs_root_c>-%control-Omrme = if_abap_behv=>mk-off.

      CLEAR: <fs_root_c>-Matnr, <fs_root_c>-Omrme.
    ENDLOOP.

    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        CREATE
          FROM lt_root_create
      MAPPED mapped
      REPORTED reported
      FAILED failed.

  ENDMETHOD.

  METHOD detGrupoEmbalagem.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        FIELDS ( CodOnu )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mat).

    LOOP AT lt_mat ASSIGNING FIELD-SYMBOL(<ls_mat>).
      IF <ls_mat>-CodOnu IS NOT INITIAL.

        CLEAR <ls_mat>-GrpEmb.
        SELECT SINGLE FROM zi_cod_onu
          FIELDS GrupoEmbalagem, ClasseRisco
          WHERE CodigoONU = @<ls_mat>-CodOnu
          INTO (@<ls_mat>-GrpEmb, @<ls_mat>-ClasseRisco).

      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        UPDATE FIELDS ( GrpEmb ClasseRisco )
        WITH CORRESPONDING #( lt_mat )
      REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD earlynumbering_cba_matcas.

    LOOP AT entities INTO DATA(ls_parent).

      SELECT codemb AS Matnr,
             omrme  AS Omrme,
             codcas AS Codcas,
             seqcas AS Seqcas
        FROM ztdp_matrmecasma
        WHERE codemb = @ls_parent-Matnr
          AND omrme  = @ls_parent-Omrme
        INTO TABLE @DATA(lt_existing_matcas).

      SELECT matnr  AS Matnr,
             omrme  AS Omrme,
             codcas AS Codcas,
             seqcas AS Seqcas
        FROM ztdp_matrmecas_d
        WHERE matnr = @ls_parent-Matnr
          AND omrme = @ls_parent-Omrme
        APPENDING CORRESPONDING FIELDS OF TABLE @lt_existing_matcas.

      DATA(max_seq) = 0.
      LOOP AT lt_existing_matcas INTO DATA(ls_existing).
        IF ls_existing-Seqcas > max_seq.
          max_seq = ls_existing-Seqcas.
        ENDIF.
      ENDLOOP.

      DATA lt_novos LIKE lt_existing_matcas.

      LOOP AT ls_parent-%target ASSIGNING FIELD-SYMBOL(<ls_target>).

        IF <ls_target>-Seqcas IS NOT INITIAL.
          APPEND VALUE #(
            %cid      = <ls_target>-%cid
            %key      = VALUE #( Matnr  = ls_parent-Matnr
                                 Omrme  = ls_parent-Omrme
                                 CodCas = <ls_target>-CodCas
                                 Seqcas = <ls_target>-Seqcas )
            %is_draft = <ls_target>-%is_draft
          ) TO mapped-matcas.
          CONTINUE.
        ENDIF.

        IF line_exists( lt_novos[ Matnr  = ls_parent-Matnr
                                  Omrme  = ls_parent-Omrme
                                  Codcas = <ls_target>-CodCas ] ).

          APPEND VALUE #(
            %cid      = <ls_target>-%cid
            %is_draft = <ls_target>-%is_draft
          ) TO failed-matcas.
          APPEND VALUE #(
            %cid      = <ls_target>-%cid
            %is_draft = <ls_target>-%is_draft
            %msg      = new_message( id       = 'ZDP_MAT'
                                     number   = '106'
                                     severity = if_abap_behv_message=>severity-error
                                     v1       = <ls_target>-CodCas )
          ) TO reported-matcas.
          CONTINUE.
        ENDIF.

        IF line_exists( lt_existing_matcas[ Matnr  = ls_parent-Matnr
                                            Omrme  = ls_parent-Omrme
                                            Codcas = <ls_target>-CodCas ] ).

          APPEND VALUE #(
            %cid      = <ls_target>-%cid
            %is_draft = <ls_target>-%is_draft
          ) TO failed-matcas.
          APPEND VALUE #(
            %cid      = <ls_target>-%cid
            %is_draft = <ls_target>-%is_draft
            %msg      = new_message( id       = 'ZDP_MAT'
                                     number   = '106'
                                     severity = if_abap_behv_message=>severity-error
                                     v1       = <ls_target>-CodCas )
          ) TO reported-matcas.
          CONTINUE.
        ENDIF.

        max_seq += 1.

        APPEND VALUE #(
          Matnr  = ls_parent-Matnr
          Omrme  = ls_parent-Omrme
          Codcas = <ls_target>-CodCas
          Seqcas = max_seq
        ) TO lt_novos.

        APPEND VALUE #(
          %cid      = <ls_target>-%cid
          %key      = VALUE #( Matnr  = ls_parent-Matnr
                               Omrme  = ls_parent-Omrme
                               CodCas = <ls_target>-CodCas
                               Seqcas = max_seq )
          %is_draft = <ls_target>-%is_draft
        ) TO mapped-matcas.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_matforn.

    LOOP AT entities INTO DATA(ls_parent).

      DATA(lv_werks_default) = '1710'.

      READ ENTITIES OF zr_mat_rme IN LOCAL MODE
        ENTITY MaterialMRE BY \_MatFornecedor
          FIELDS ( Lifnr Werks )
          WITH VALUE #( ( %tky = ls_parent-%tky ) )
        RESULT DATA(lt_existentes).

      LOOP AT ls_parent-%target ASSIGNING FIELD-SYMBOL(<ls_target>).

        IF line_exists( lt_existentes[ Matnr = ls_parent-Matnr
                                       Omrme = ls_parent-Omrme
                                       Lifnr = <ls_target>-Lifnr
                                       Werks = lv_werks_default ] ).

          APPEND VALUE #(
            %cid      = <ls_target>-%cid
            %is_draft = <ls_target>-%is_draft
          ) TO failed-matfornecedor.

          APPEND VALUE #(
            %cid      = <ls_target>-%cid
            %is_draft = <ls_target>-%is_draft
            %msg      = new_message( id       = 'ZDP_MAT'
                                     number   = '107'
                                     severity = if_abap_behv_message=>severity-error
                                     v1       = <ls_target>-Lifnr
                                     v2       = lv_werks_default )
          ) TO reported-matfornecedor.
          CONTINUE.
        ENDIF.

        APPEND VALUE #(
          %cid      = <ls_target>-%cid
          %key      = VALUE #( Matnr = ls_parent-Matnr
                               Omrme = ls_parent-Omrme
                               Lifnr = <ls_target>-Lifnr
                               Werks = lv_werks_default )
          %is_draft = <ls_target>-%is_draft
        ) TO mapped-matfornecedor.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_matparc.
    LOOP AT entities INTO DATA(ls_parent).

      DATA(lv_werks_default) = '1710'.

      READ ENTITIES OF zr_mat_rme IN LOCAL MODE
        ENTITY MaterialMRE BY \_MatParceiro
          FIELDS ( Lifnr Werks )
          WITH VALUE #( ( %tky = ls_parent-%tky ) )
        RESULT DATA(lt_existentes).

      LOOP AT ls_parent-%target ASSIGNING FIELD-SYMBOL(<ls_target>).

        IF line_exists( lt_existentes[ Matnr = ls_parent-Matnr
                                       Omrme = ls_parent-Omrme
                                       Lifnr = <ls_target>-Lifnr
                                       Werks = lv_werks_default ] ).

          APPEND VALUE #(
            %cid      = <ls_target>-%cid
            %is_draft = <ls_target>-%is_draft
          ) TO failed-matparceiro.

          APPEND VALUE #(
            %cid      = <ls_target>-%cid
            %is_draft = <ls_target>-%is_draft
            %msg      = new_message( id       = 'ZDP_MAT'
                                     number   = '107'
                                     severity = if_abap_behv_message=>severity-error
                                     v1       = <ls_target>-Lifnr
                                     v2       = lv_werks_default )
          ) TO reported-matparceiro.
          CONTINUE.
        ENDIF.

        APPEND VALUE #(
          %cid      = <ls_target>-%cid
          %key      = VALUE #( Matnr = ls_parent-Matnr
                               Omrme = ls_parent-Omrme
                               Lifnr = <ls_target>-Lifnr
                               Werks = lv_werks_default )
          %is_draft = <ls_target>-%is_draft
        ) TO mapped-matparceiro.

      ENDLOOP.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_tsojtso DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setControlFields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR TsoJtso~setControlFields.

    METHODS setUpdateFields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR TsoJtso~setUpdateFields.

ENDCLASS.

CLASS lhc_tsojtso IMPLEMENTATION.

  METHOD setControlFields.

    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_time) = cl_abap_context_info=>get_system_time( ).
    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY TsoJtso
        UPDATE FIELDS ( DataAlt HoraAlt )
        WITH VALUE #( FOR key IN keys (
                      %tky    = key-%tky
                      DataAlt = lv_date
                      HoraAlt = lv_time
                      ) )
      REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD setUpdateFields.

    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_time) = cl_abap_context_info=>get_system_time( ).
    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY TsoJtso
        UPDATE FIELDS ( UserAlt DataAlt HoraAlt )
        WITH VALUE #( FOR key IN keys (
                      %tky             = key-%tky
                      UserAlt          = lv_user
                      DataAlt          = lv_date
                      HoraAlt          = lv_time
                      %control-UserAlt = if_abap_behv=>mk-on
                      %control-DataAlt = if_abap_behv=>mk-on
                      %control-HoraAlt = if_abap_behv=>mk-on
                      ) )
      REPORTED DATA(lt_reported).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_matcas DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setControlFields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MatCAS~setControlFields.
    METHODS detDescricaoCas FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MatCAS~detDescricaoCas.
    METHODS validateMaterialProibido FOR VALIDATE ON SAVE
      IMPORTING keys FOR MatCAS~validateMaterialProibido.

ENDCLASS.

CLASS lhc_matcas IMPLEMENTATION.

  METHOD setControlFields.
    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_time) = cl_abap_context_info=>get_system_time( ).

    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MatCAS
        UPDATE FIELDS ( Uname Aedat Uptim )
        WITH VALUE #( FOR key IN keys (
                      %tky           = key-%tky
                      Aedat          = lv_date
                      Uptim          = lv_time
                      %control-Uname = if_abap_behv=>mk-on
                      %control-Aedat = if_abap_behv=>mk-on
                      %control-Uptim = if_abap_behv=>mk-on
                      ) )
      REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD detDescricaoCas.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MatCAS
        FIELDS ( Codcas )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_matcas).

    LOOP AT lt_matcas ASSIGNING FIELD-SYMBOL(<ls_matcas>).

      IF <ls_matcas>-Codcas IS NOT INITIAL.

        SELECT SINGLE DescasPt, DescasEn, GrupoRestricao
          FROM zi_mat_cas_number
          WHERE codcas = @<ls_matcas>-Codcas
          INTO @DATA(ls_cas).

        IF sy-subrc = 0.

          DATA(lv_status_matcas) = 'A'.

          MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
            ENTITY MatCAS
              UPDATE FIELDS ( DescricaoPt DescricaoEn GrupoRestricao Status StatusText )
              WITH VALUE #( ( %tky           = <ls_matcas>-%tky
                              DescricaoPt    = ls_cas-DescasPt
                              DescricaoEn    = ls_cas-DescasEn
                              GrupoRestricao = ls_cas-GrupoRestricao
                              Status         = lv_status_matcas
                              StatusText     = SWITCH #( lv_status_matcas
                                                         WHEN 'A' THEN 'ADD'
                                                         WHEN 'U' THEN 'UPD'
                                                         WHEN 'D' THEN 'DEL'
                                                         ELSE ' ' )
                          ) )
            REPORTED DATA(lt_reported).

        ENDIF.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateMaterialProibido.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MatCAS
        FIELDS ( GrupoRestricao ) WITH CORRESPONDING #( keys )
        RESULT DATA(MatCAS)
      ENTITY MatCAS BY \_MatRme
        FROM CORRESPONDING #( keys )
      LINK DATA(links).

    LOOP AT MatCAS ASSIGNING FIELD-SYMBOL(<matcas>).

      APPEND VALUE #( %tky        = <matcas>-%tky
                      %state_area = 'VALIDATE_MATERIAL_PROIBIDO' ) TO reported-matcas.

      IF <matcas>-GrupoRestricao = '1'.
        APPEND VALUE #( %tky = <matcas>-%tky ) TO failed-matcas.

        APPEND VALUE #(
          %tky            = <matcas>-%tky
          %state_area     = 'VALIDATE_MATERIAL_PROIBIDO'
          %msg            = new_message( id               = 'ZDP_MAT'
                                         number           = 101
                                         severity         = if_abap_behv_message=>severity-error )
          %element-Codcas = if_abap_behv=>mk-on
          %path           = VALUE #(     materialmre-%tky = links[ KEY id source-%tky = <matcas>-%tky ]-target-%tky )
        ) TO reported-matcas.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_matrmecontrol DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS detMatCtrlFields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MatRmeControl~detMatCtrlFields.

ENDCLASS.

CLASS lhc_matrmecontrol IMPLEMENTATION.

  METHOD detMatCtrlFields.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MatRmeControl
        FIELDS ( ExportLicense )
        WITH CORRESPONDING #( keys )
      RESULT DATA(MatRmeControl).

    LOOP AT MatRmeControl ASSIGNING FIELD-SYMBOL(<ls_matctrl>).

      IF <ls_matctrl>-ExportLicense IS NOT INITIAL.

        DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
        DATA(lv_time) = cl_abap_context_info=>get_system_time( ).
        DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

        IF sy-subrc = 0.

          DATA(lv_status) = 'A'.

          MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
            ENTITY MatRmeControl
              UPDATE FIELDS ( ExpSecurity Status StatusText Uname Aedat Uptim )
              WITH VALUE #( ( %tky       = <ls_matctrl>-%tky
                              Aedat      = lv_date
                              Uptim      = lv_time
                              Status     = lv_status
                              StatusText = SWITCH #( lv_status
                                                     WHEN 'A' THEN 'ADD'
                                                     WHEN 'U' THEN 'UPD'
                                                     WHEN 'D' THEN 'DEL'
                                                     ELSE ' ' )
                          ) )
            REPORTED DATA(lt_reported).

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_matparceiro DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS: c_add      TYPE abap_boolean VALUE 'A',
               c_parceiro TYPE abap_boolean VALUE 'P',
               c_900000   TYPE c LENGTH 10 VALUE '0003000000'.

    METHODS setDefaultValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MatParceiro~setDefaultValues.
    METHODS validatePartnerProibido FOR VALIDATE ON SAVE
      IMPORTING keys FOR MatParceiro~validatePartnerProibido.

ENDCLASS.

CLASS lhc_matparceiro IMPLEMENTATION.

  METHOD setDefaultValues.

    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_time) = cl_abap_context_info=>get_system_time( ).

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MatParceiro
        FIELDS ( Sperrfkt )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_parceiros).

    DATA lt_update TYPE TABLE FOR UPDATE zr_mat_rme\\MatParceiro.

    LOOP AT lt_parceiros INTO DATA(ls_parceiro).
      IF ls_parceiro-Sperrfkt IS INITIAL.
        APPEND VALUE #(
          %tky       = ls_parceiro-%tky
          Sperrfkt   = 'XX'
          Dataincl   = lv_date
          Horaincl   = lv_time
          Indempa    = c_parceiro
          Status     = c_add
          StatusText = SWITCH #( c_add
                                 WHEN 'A' THEN 'ADD'
                                 WHEN 'U' THEN 'UPD'
                                 WHEN 'D' THEN 'DEL'
                                 ELSE ' ' )
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
        ENTITY MatParceiro
          UPDATE FIELDS ( Dataincl Horaincl Indempa Sperrfkt Status StatusText )
          WITH lt_update
        REPORTED DATA(lt_reported).
    ENDIF.

  ENDMETHOD.

  METHOD validatePartnerProibido.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MatParceiro
        FIELDS ( Lifnr ) WITH CORRESPONDING #( keys )
        RESULT DATA(MatParceiro)
      ENTITY MatParceiro BY \_MatRme
        FROM CORRESPONDING #( keys )
      LINK DATA(links).

    LOOP AT MatParceiro ASSIGNING FIELD-SYMBOL(<matparceiro>).

      APPEND VALUE #( %tky        = <matparceiro>-%tky
                      %state_area = 'VALIDATE_PARTNER_PROIBIDO' ) TO reported-matparceiro.

      IF <matparceiro>-Lifnr < c_900000.
        APPEND VALUE #( %tky = <matparceiro>-%tky ) TO failed-matparceiro.

        APPEND VALUE #(
          %tky           = <matparceiro>-%tky
          %state_area    = 'VALIDATE_PARTNER_PROIBIDO'
          %msg           = new_message( id               = 'ZDP_MAT'
                                        number           = 102
                                        severity         = if_abap_behv_message=>severity-error )
          %element-Lifnr = if_abap_behv=>mk-on
          %path          = VALUE #(     materialmre-%tky = links[ KEY id source-%tky = <matparceiro>-%tky ]-target-%tky )
        ) TO reported-matparceiro.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_matfornecedor DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS: c_add        TYPE abap_boolean VALUE 'A',
               c_fornecedor TYPE abap_boolean VALUE 'E',
               c_900000     TYPE c LENGTH 10 VALUE '0003000000'.

    METHODS setDefaultValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MatFornecedor~setDefaultValues.
    METHODS validateSupplierProibido FOR VALIDATE ON SAVE
      IMPORTING keys FOR MatFornecedor~validateSupplierProibido.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR MatFornecedor RESULT result.

ENDCLASS.

CLASS lhc_matfornecedor IMPLEMENTATION.

  METHOD setDefaultValues.

    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_time) = cl_abap_context_info=>get_system_time( ).

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MatFornecedor
        FIELDS ( Sperrfkt )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_forn).

    DATA lt_update TYPE TABLE FOR UPDATE zr_mat_rme\\MatFornecedor.

    LOOP AT lt_forn INTO DATA(ls_forn).
      IF ls_forn-Sperrfkt IS INITIAL.
        APPEND VALUE #(
          %tky       = ls_forn-%tky
          Sperrfkt   = 'XX'
          Dataincl   = lv_date
          Horaincl   = lv_time
          Indempa    = c_fornecedor
          Status     = c_add
          StatusText = SWITCH #( c_add
                                 WHEN 'A' THEN 'ADD'
                                 WHEN 'U' THEN 'UPD'
                                 WHEN 'D' THEN 'DEL'
                                 ELSE ' ' )
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
        ENTITY MatFornecedor
          UPDATE FIELDS ( Dataincl Horaincl Indempa Sperrfkt Status StatusText  )
          WITH lt_update
        REPORTED DATA(lt_reported).
    ENDIF.

  ENDMETHOD.

  METHOD validateSupplierProibido.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
       ENTITY MatFornecedor
         FIELDS ( Lifnr ) WITH CORRESPONDING #( keys )
         RESULT DATA(MatFornecedor)
       ENTITY MatFornecedor BY \_MatRme
         FROM CORRESPONDING #( keys )
       LINK DATA(links).

    LOOP AT MatFornecedor ASSIGNING FIELD-SYMBOL(<matfornecedor>).

      APPEND VALUE #( %tky        = <matfornecedor>-%tky
                      %state_area = 'VALIDATE_SUPPLIER_PROIBIDO' ) TO reported-matfornecedor.

      IF <matfornecedor>-Lifnr >= c_900000.
        APPEND VALUE #( %tky = <matfornecedor>-%tky ) TO failed-matfornecedor.

        APPEND VALUE #(
          %tky           = <matfornecedor>-%tky
          %state_area    = 'VALIDATE_SUPPLIER_PROIBIDO'
          %msg           = new_message( id               = 'ZDP_MAT'
                                        number           = 103
                                        severity         = if_abap_behv_message=>severity-error )
          %element-Lifnr = if_abap_behv=>mk-on
          %path          = VALUE #(     materialmre-%tky = links[ KEY id source-%tky = <matfornecedor>-%tky ]-target-%tky )
        ) TO reported-matfornecedor.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_matkit DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS c_add      TYPE abap_boolean VALUE 'A'.

    METHODS setControlFields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MatKit~setControlFields.

ENDCLASS.

CLASS lhc_matkit IMPLEMENTATION.

  METHOD setControlFields.

    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_time) = cl_abap_context_info=>get_system_time( ).

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MatKit
        FIELDS ( Matnrkit )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_matkit).

    DATA lt_update TYPE TABLE FOR UPDATE zr_mat_rme\\MatKit.

    LOOP AT lt_matkit ASSIGNING FIELD-SYMBOL(<ls_matkit>).

      IF <ls_matkit>-Matnrkit IS NOT INITIAL.
        " Seleciona Material pelo cod Fabricante
        SELECT SINGLE FROM i_product
            FIELDS product
            WHERE ProductManufacturerNumber = @<ls_matkit>-Matnrkit
            INTO @<ls_matkit>-CodigoEmbraer.

        APPEND VALUE #(
          %tky          = <ls_matkit>-%tky
          CodigoEmbraer = <ls_matkit>-CodigoEmbraer
          Dataincl      = lv_date
          Horaincl      = lv_time
          Status        = c_add
          StatusText    = SWITCH #( c_add
                                    WHEN 'A' THEN 'ADD'
                                    WHEN 'U' THEN 'UPD'
                                    WHEN 'D' THEN 'DEL'
                                    ELSE ' ' )
        ) TO lt_update.
      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.

      MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
        ENTITY MatKit
          UPDATE FIELDS ( CodigoEmbraer Dataincl Horaincl Status StatusText  )
          WITH lt_update
        REPORTED DATA(lt_reported).

    ENDIF.

  ENDMETHOD.

ENDCLASS.