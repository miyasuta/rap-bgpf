@EndUserText.label: 'Flight Occupancy'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity Zc_Flightoccupancy 
provider contract transactional_query
as projection on ZI_FlightOccupancy
{
    key AirlineID,
    key ConnectionID,
    key FlightDate,
    Price,
    CurrencyCode,
    PlaneType,
    MaximumSeats,
    OccupiedSeats,
    Criticality,
    CalcStatus,
    CalcStatusDisp,    
    OccupancyRate,
    OccupancyUnit,
    /* Associations */
//    _Airline,
    _Connection,
    _Currency
}
