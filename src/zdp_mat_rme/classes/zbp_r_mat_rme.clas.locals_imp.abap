CLASS lsc_zr_mat_rme DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zr_mat_rme IMPLEMENTATION.

  METHOD save_modified.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
        ENTITY MaterialMRE
          ALL FIELDS
          WITH CORRESPONDING #( update-materialmre )
        RESULT DATA(lt_materialmre).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*     Gravar textos do Material
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA:
      lt_in_inst_tab TYPE cl_abap_parallel=>t_in_inst_tab,
      lt_messages    TYPE flog_t_message.

    DATA: lv_omrme    TYPE matnr,
          lv_language TYPE spras.

    " Ao criar o material, os textos de manuseio, armazenamento, transporte e notificação também podem ser modificados.
    " Para garantir a consistência dos
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

      LOOP AT lt_messages INTO DATA(ls_message)
        WHERE msgty = 'E' OR msgty = 'A'.

        APPEND VALUE #(
          %key        = <fs_materialmre>-%key
          %state_area = 'SAVE_MODIFIED'
          %msg        = new_message(
          id       = ls_message-msgid
          number   = ls_message-msgno
          severity = if_abap_behv_message=>severity-error
          v1       = ls_message-msgv1
          v2       = ls_message-msgv2
          v3       = ls_message-msgv3
          v4       = ls_message-msgv4 )
        ) TO reported-materialmre.
      ENDLOOP.

      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Material / Classe GHS
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      IF <fs_materialmre>-%control-CodGHS = cl_abap_behv=>flag_changed.

        DATA(ls_materialmre_ghs) = lt_materialmre[
          KEY entity Matnr = <fs_materialmre>-Matnr
                     omrme = <fs_materialmre>-Omrme
        ].
        DATA(lv_cod_ghs) = COND #( WHEN <fs_materialmre>-%control-CodGHS = cl_abap_behv=>flag_changed
                                  THEN <fs_materialmre>-CodGHS
                                  ELSE ls_materialmre_ghs-CodGHS ).
        DELETE FROM ztdp_mat_cl_ghs WHERE matnr = @<fs_materialmre>-Matnr AND omrme = @<fs_materialmre>-Omrme.
        INSERT ztdp_mat_cl_ghs FROM TABLE @( VALUE #(
          ( matnr   = <fs_materialmre>-Matnr
            omrme   = <fs_materialmre>-Omrme
            cod_ghs = lv_cod_ghs ) ) ).
      ENDIF.

    ENDLOOP.

    " Ao modificar o material, os textos de manuseio, armazenamento, transporte e notificação também podem ser modificados.
    " Para garantir a consistência dos
    LOOP AT update-materialmre ASSIGNING <fs_materialmre>.

      lv_omrme = <fs_materialmre>-Omrme.
      lv_language = sy-langu.

      lt_messages = NEW zcl_mat_rme_save( iv_material = CONV string( lv_omrme )
                                          iv_manper   = lt_materialmre[ KEY entity Matnr = <fs_materialmre>-Matnr omrme = lv_omrme ]-manpertext
                                          iv_manpre   = lt_materialmre[ KEY entity Matnr = <fs_materialmre>-Matnr omrme = lv_omrme ]-manpretext
                                          iv_manret   = lt_materialmre[ KEY entity Matnr = <fs_materialmre>-Matnr omrme = lv_omrme ]-manrettext
                                          iv_mannot   = lt_materialmre[ KEY entity Matnr = <fs_materialmre>-Matnr omrme = lv_omrme ]-mannottext )->save_text( ).

      LOOP AT lt_messages INTO ls_message
        WHERE msgty = 'E' OR msgty = 'A'.

        APPEND VALUE #(
          %key        = <fs_materialmre>-%key
          %state_area = 'SAVE_MODIFIED'
          %msg        = new_message(
          id       = ls_message-msgid
          number   = ls_message-msgno
          severity = if_abap_behv_message=>severity-error
          v1       = ls_message-msgv1
          v2       = ls_message-msgv2
          v3       = ls_message-msgv3
          v4       = ls_message-msgv4 )
        ) TO reported-materialmre.
      ENDLOOP.

      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Material / Classe GHS
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      IF <fs_materialmre>-%control-CodGHS = cl_abap_behv=>flag_changed.

        ls_materialmre_ghs = lt_materialmre[
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

      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      "    Material / Classe de Risco
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      IF <fs_materialmre>-%control-Doctype = cl_abap_behv=>flag_changed OR <fs_materialmre>-%control-Docnro = cl_abap_behv=>flag_changed.

        DATA(ls_materialmre) = lt_materialmre[
          KEY entity Matnr = <fs_materialmre>-Matnr
                     omrme = <fs_materialmre>-Omrme
        ].
        DATA(lv_codproj_aenv) = ls_materialmre-codprojaenv.
        DATA(lv_doctype) = COND #( WHEN <fs_materialmre>-%control-Doctype = cl_abap_behv=>flag_changed
                                   THEN <fs_materialmre>-Doctype
                                   ELSE ls_materialmre-Doctype ).
        DATA(lv_docnro)  = COND #( WHEN <fs_materialmre>-%control-Docnro = cl_abap_behv=>flag_changed
                                   THEN <fs_materialmre>-Docnro
                                   ELSE ls_materialmre-Docnro ).
        DELETE FROM ztdp_matrmeaplma WHERE matnr         = @<fs_materialmre>-Matnr
                                       AND omrme         = @<fs_materialmre>-Omrme
                                       AND cod_proj_aenv = @lv_codproj_aenv.
        INSERT ztdp_matrmeaplma FROM TABLE @( VALUE #(
          ( matnr         = <fs_materialmre>-Matnr
            omrme         = <fs_materialmre>-Omrme
            cod_proj_aenv = lv_codproj_aenv
            Doctype       = lv_doctype
            Docnro        = lv_docnro
          ) ) ).

      ENDIF.

    ENDLOOP.

    LOOP AT delete-materialmre ASSIGNING FIELD-SYMBOL(<fs_materialmre_del>).

      DELETE FROM ztdp_matrmeaplma WHERE matnr         = @<fs_materialmre_del>-Matnr
                                     AND omrme         = @<fs_materialmre_del>-Omrme.

      DELETE FROM ztdp_mat_cl_ghs WHERE matnr         = @<fs_materialmre_del>-Matnr
                                    AND omrme         = @<fs_materialmre_del>-Omrme.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_materialmre DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

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
    METHODS setDefaultValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MaterialMRE~setDefaultValues.

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

    " Variáveis para obtenção do número OMRME via SNRO ZDPOMRME (subobjeto 01)
    DATA: lv_omrme_num        TYPE cl_numberrange_runtime=>nr_number,
          lv_omrme_returncode TYPE cl_numberrange_runtime=>nr_returncode,
          lv_omrme_qty        TYPE cl_numberrange_runtime=>nr_returned_quantity.

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

            " Obtém o próximo OMRME do objeto ZDPOMRME, range 01
            CLEAR: lv_omrme_num, lv_omrme_returncode, lv_omrme_qty.

            TRY.

                cl_numberrange_runtime=>number_get(
                  EXPORTING
                    nr_range_nr       = '01'
                    object            = 'ZDPOMRME'
                    quantity          = '1'
                  IMPORTING
                    number            = lv_omrme_num
                    returncode        = lv_omrme_returncode
                    returned_quantity = lv_omrme_qty ).

                wa_entity-Omrme = lv_omrme_num.

              CATCH cx_number_ranges INTO DATA(lo_ex_nr).

                APPEND VALUE #(
                  %cid        = wa_entity-%cid
                  %state_area = 'EARLYNUMBERINGCREATE_OMRME'
                  %msg        = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text     = |Erro ao obter OMRME (ZDPOMRME/01): { lo_ex_nr->get_text( ) }| )
                ) TO reported-materialmre.

            ENDTRY.

          ENDIF.

          IF ls_message-msgty = 'E' OR
             ls_message-msgty = 'A'.
            APPEND VALUE #(
              %cid        = wa_entity-%cid
              %state_area = 'EARLYNUMBERINGCREATE'
              %msg        = new_message(
              id       = ls_message-msgid
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

    " Read the data from the newly created draft (using %is_draft = '01')
    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        FIELDS ( StatusCRUD )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_draft_data).

    " Modify specific draft fields
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
            %msg        = new_message_with_text(
            severity = if_abap_behv_message=>severity-success
            text     = |Material { <material_rme>-Matnr } cadastrado em Dados Mestres| )
          ) TO reported-materialmre.
        ELSE.
          APPEND VALUE #(
            %tky        = <material_rme>-%tky
            %state_area = 'DEFAULT_MESSAGE'
            %msg        = new_message_with_text(
            severity = if_abap_behv_message=>severity-information
            text     = |Material { <material_rme>-Matnr } Aguardando Aprovação| )
          ) TO reported-materialmre.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD detAlteraCriticidade.

    " Ler os dados atuais das instâncias
    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        FIELDS ( CodSitMat )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mat)
      FAILED DATA(lt_failed).

    " Preparar tabela de updates
    DATA lt_update TYPE TABLE FOR UPDATE zr_mat_rme\\MaterialMRE.

    LOOP AT lt_mat INTO DATA(ls_mat).

      DATA(lv_CodSitMatCritic) = SWITCH #( ls_mat-CodSitMat
        WHEN 'K' THEN '2'
        WHEN 'D' THEN '1'
        WHEN 'L' THEN '3'
        ELSE '2' ).

      APPEND VALUE #(
        %tky                       = ls_mat-%tky
        SitMatCriticality          = lv_CodSitMatCritic
        %control-SitMatCriticality = if_abap_behv=>mk-on
      ) TO lt_update.

    ENDLOOP.

    " Modificar as instâncias
    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        UPDATE FIELDS ( SitMatCriticality )
        WITH lt_update
      REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD detUnidadeMedida.

    " Ler os dados atuais das instâncias
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

    " Modificar as instâncias
    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
    ENTITY MaterialMRE
        UPDATE FIELDS ( meins )
        WITH CORRESPONDING #( lt_mat )
    REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD setDefaultValues.

    READ ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        FIELDS ( CompanyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mat).

    DATA lt_update TYPE TABLE FOR UPDATE zr_mat_rme\\MaterialMRE.

    LOOP AT lt_mat INTO DATA(ls_mat).
      IF ls_mat-CompanyCode IS INITIAL.
        APPEND VALUE #(
          %tky                 = ls_mat-%tky
          CompanyCode          = '1710'
          %control-CompanyCode = if_abap_behv=>mk-on
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zr_mat_rme IN LOCAL MODE
      ENTITY MaterialMRE
        UPDATE FIELDS ( CompanyCode )
        WITH lt_update
      REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD copy.

    " Lê os dados completos dos registros selecionados
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

ENDCLASS.
