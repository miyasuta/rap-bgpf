CLASS zcl_flight_operation_contr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_flight_keys,
             carrier_id    TYPE /dmo/carrier_id,
             connection_id TYPE /dmo/connection_id,
             flight_date   TYPE /dmo/flight_date,
           END OF ty_flight_keys.

    INTERFACES if_serializable_object .
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single .

    METHODS constructor
      IMPORTING i_flight_keys TYPE ty_flight_keys.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA m_flight_keys TYPE ty_flight_keys.
ENDCLASS.



CLASS zcl_flight_operation_contr IMPLEMENTATION.
  METHOD constructor.
    m_flight_keys = i_flight_keys.
  ENDMETHOD.


  METHOD if_bgmc_op_single~execute.
    "時間のかかる処理を再現
    WAIT UP TO 10 SECONDS.

    cl_abap_tx=>save( ).

    SELECT SINGLE MaximumSeats,
                  OccupiedSeats
    FROM /DMO/I_Flight
    WHERE AirlineID = @m_flight_keys-carrier_id
      AND ConnectionID = @m_flight_keys-connection_id
      AND FlightDate = @m_flight_keys-flight_date
    INTO @DATA(flight).

    IF sy-subrc <> 0 OR flight-MaximumSeats = 0.
      MODIFY zflightoccupancy FROM @( VALUE #( carrier_id = m_flight_keys-carrier_id
                                               connection_id = m_flight_keys-connection_id
                                               flight_date = m_flight_keys-flight_date
                                               occupancy_rate = 0
                                               occupancy_unit = '%'
                                               calc_status = '3' ) ).
      RETURN.
    ENDIF.

    MODIFY zflightoccupancy FROM @( VALUE #( carrier_id = m_flight_keys-carrier_id
                                             connection_id = m_flight_keys-connection_id
                                             flight_date = m_flight_keys-flight_date
                                             occupancy_rate = flight-OccupiedSeats / flight-MaximumSeats * 100
                                             occupancy_unit = '%'
                                             calc_status = '2' ) ).

*    "EMLで更新してよいのか？
*    modify ENTITIES OF ZI_FlightOccupancy
*      ENTITY FlightOccupacy
*      UPDATE FIELDS ( OccupancyRate CalcStatus )
*      with value #( ( AirlineID = m_flight_keys-carrier_id
*                      ConnectionID = m_flight_keys-connection_id
*                      FlightDate = m_flight_keys-flight_date
*                      OccupancyRate = flight-OccupiedSeats / flight-OccupiedSeats * 100
*                      CalcStatus = '2'  ) ).


  ENDMETHOD.
ENDCLASS.
