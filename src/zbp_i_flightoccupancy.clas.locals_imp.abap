CLASS lhc_FlightOccupacy DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR FlightOccupacy RESULT result.
    METHODS calculateoccupacyrate FOR MODIFY
      IMPORTING keys FOR ACTION flightoccupacy~calculateoccupacyrate RESULT result.



ENDCLASS.

CLASS lhc_FlightOccupacy IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.



  METHOD calculateOccupacyRate.
    "start bgPF

    "set status
    MODIFY ENTITIES OF ZI_FlightOccupancy IN LOCAL MODE
      ENTITY FlightOccupacy
      UPDATE FIELDS ( calcStatus )
      WITH VALUE #( FOR status IN keys ( %tky = status-%tky
                                         CalcStatus = 1 ) ).

    "return result
    READ ENTITIES OF ZI_FlightOccupancy IN LOCAL MODE
      ENTITY FlightOccupacy
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(occupacy).

    result = VALUE #( FOR data IN occupacy ( %tky = data-%tky
                                             %param = data ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_FLIGHTOCCUPANCY DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_FLIGHTOCCUPANCY IMPLEMENTATION.

  METHOD save_modified.
    DATA lo_operation TYPE REF TO if_bgmc_op_single.
    DATA lo_process TYPE REF TO if_bgmc_process_single_op.
    DATA lo_process_monitor TYPE REF TO if_bgmc_process_monitor.

    LOOP AT update-flightoccupacy INTO DATA(occupacy).
      "persist status
      MODIFY zflightoccupancy FROM @( VALUE #( carrier_id = occupacy-AirlineID
                    connection_id = occupacy-ConnectionID
                    flight_date = occupacy-FlightDate
                    calc_status = occupacy-CalcStatus
                    occupancy_rate = 0
                    occupancy_unit = '%' ) ).

      "trigger bgPF
      lo_operation = NEW zcl_flight_operation_contr( i_flight_keys = VALUE #( carrier_id = occupacy-AirlineID
                                                                              connection_id = occupacy-ConnectionID                                                                              flight_date = occupacy-FlightDate ) ).
      TRY.
          lo_process = cl_bgmc_process_factory=>get_default( )->create( ).
          lo_process->set_name( 'Calc Flight Occupancy Test'
                   )->set_operation( lo_operation ).
          lo_process_monitor = lo_process->save_for_execution( ).
        CATCH cx_bgmc INTO DATA(lx_bgmc).
      ENDTRY.

    ENDLOOP.


  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
