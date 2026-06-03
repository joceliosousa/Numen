CLASS zcl_mat_rme_save DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*    INTERFACES if_serializable_object .
*    INTERFACES if_abap_parallel .

    METHODS constructor
      IMPORTING
        !iv_material TYPE string
        !iv_Manper   TYPE string
        !iv_Manpre   TYPE string
        !iv_Manret   TYPE string
        !iv_Mannot   TYPE string.

    METHODS save_text
      RETURNING
        VALUE(re_t_messages) TYPE flog_t_message .

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA:
      gv_error         TYPE c,
      gv_material      TYPE matnr,
      gv_manper        TYPE string,
      gv_manpre        TYPE string,
      gv_manret        TYPE string,
      gv_mannot        TYPE string,
      gv_dummy_message TYPE string.

    DATA gt_messages TYPE flog_t_message.

    METHODS get_messages
      RETURNING
        VALUE(re_t_messages) TYPE flog_t_message .

ENDCLASS.

CLASS zcl_mat_rme_save IMPLEMENTATION.

  METHOD save_text.

    DATA:
      lv_name   TYPE string,
      lv_string TYPE string.

    lv_name = gv_material.

    lv_string = gv_manper.

    CALL METHOD zcl_mat_maintain_texts=>save_text
      EXPORTING
        iv_string   = lv_string
        iv_id       = 'IVER'
        iv_language = sy-langu
        iv_name     = lv_name
        iv_object   = 'ZMANPER'.

    lv_string = gv_manpre.

    CALL METHOD zcl_mat_maintain_texts=>save_text
      EXPORTING
        iv_string   = lv_string
        iv_id       = 'IVER'
        iv_language = sy-langu
        iv_name     = lv_name
        iv_object   = 'ZMANPRE'.

    lv_string = gv_manret.

    CALL METHOD zcl_mat_maintain_texts=>save_text
      EXPORTING
        iv_string   = lv_string
        iv_id       = 'IVER'
        iv_language = sy-langu
        iv_name     = lv_name
        iv_object   = 'ZMANRET'.

    lv_string = gv_mannot.

    CALL METHOD zcl_mat_maintain_texts=>save_text
      EXPORTING
        iv_string   = lv_string
        iv_id       = 'IVER'
        iv_language = sy-langu
        iv_name     = lv_name
        iv_object   = 'ZMANNOT'.

    re_t_messages = get_messages( ).

  ENDMETHOD.

  METHOD constructor.

    gv_material = iv_material.
    gv_manper   = iv_manper.
    gv_manpre   = iv_manpre.
    gv_manret   = iv_manret.
    gv_mannot   = iv_mannot.

  ENDMETHOD.

  METHOD get_messages.

    re_t_messages = gt_messages.

  ENDMETHOD.

ENDCLASS.
