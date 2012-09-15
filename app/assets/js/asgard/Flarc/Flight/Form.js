



Ext.define('Asgard.Flight.ConfigurationPicker', {
  extend: 'Asgard.ObjectPicker',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.PlaneType',
    'Asgard.Flarc.PlaneType.Configuration.View',
  ],

  items: [
   {
    xtype: 'objectview',
    asgardObject: 'Asgard.Flarc.PlaneType.Configuration',
    store: {
      model: 'Flarc.PlaneType.Configuration',
    },
   }
  ],

  queryMode: 'local',

  searchIn: [ 'name' ],
  defaultSortField: 'name',
  sortFields: [
    { label: 'Name', field: 'name' },
  ],
});


Ext.define('Asgard.Flarc.Flight.Form', {
  extend: 'Asgard.form.ModelFormPanel',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Flight',
    'Flarc.Plane',
    'Asgard.Flarc.Plane.ReferenceField',
    'Asgard.Flarc.PlaneType.Configuration.ReferenceField',
    'Asgard.gmaps.Loader',
    'Asgard.gmaps.Panel',
    'Asgard.Core.Person.ReferenceField',
    'Asgard.Flarc.Pilot.ReferenceField',
    'Asgard.Flarc.Championship.Flight.CollectionField',
  ],
  alias: 'widget.flarc_flight_form',
  model: 'Flarc.Flight',

  layout: {
    type: 'hbox',
    align: 'stretch',
  },

  items: [
   {
    xtype: 'fieldcontainer',
    layout: 'anchor',
    flex: 1,
    items: [
     {
      xtype: 'datetimefield',
      fieldLabel: 'Takeoff',
      name: 'takeoff_time',
     },
     {
      xtype: 'datetimefield',
      fieldLabel: 'Landing',
      name: 'landing_time',
     },
     {
      xtype: 'flarc_pilot',
      fieldLabel: 'Pilot',
      name: 'pilot_id',
     },
     {
      xtype: 'core_person',
      fieldLabel: 'Passenger',
      name: 'passenger_id',
     },
     {
      xtype: 'flarc_plane',
      fieldLabel: 'Plane',
      name: 'plane',
      reloadModelWith: { view: 'edit' },
     },
     {
      xtype: 'flarc_planetypeconfiguration',
      fieldLabel: 'Configuration',
      name: 'plane_type_configuration_id',
      pickerClass: 'Asgard.Flight.ConfigurationPicker',
     },
     {
      xtype: 'fieldcontainer',
      fieldLabel: 'Championships',
      items: {
        xtype: 'flarc_championshipflights',
        fieldLabel: 'Championships',
        name: 'championship_flights',
        width: 500,
        height: 150,
      },
     },
     {
      xtype: 'textarea',
      fieldLabel: 'Private notes',
      name: 'notes_private',
      anchor: '100%',
     },
     {
      xtype: 'textarea',
      fieldLabel: 'Public notes',
      name: 'notes_public',
      anchor: '100%',
     },
    ],
   },
   {
    xtype: 'gmappanel',
    flex: 1,
    displayGeoErrors: true,
    zoomLevel: 14,
    gmapType: 'TERRAIN',
    mapConfOpts: [ 'enableScrollWheelZoom', 'enableDragging' ],
    mapControls: [ 'GSmallMapControl', 'GMapTypeControl' ],
    setCenter: {
      lat: 45.708996,
      lng: 8.471425
    },
   },
  ],

  initComponent: function() {
    var me = this;

    me.callParent(arguments);

    me.down('flarc_plane').on('change', function(a,b,c) {
      var rec = me.down('flarc_plane').getRecord();
      if (rec) {
        var range = rec.getplane_type().configurations().getRange();

        me.down('flarc_planetypeconfiguration').getPicker().getStore().
          loadRecords(range, { addRecords: false });

        me.down('flarc_planetypeconfiguration').setValue(range[0]);
      }
    });

    me.on('recordloaded', function(record) {
      if (!record.get('encoded_polyline'))
        return;

      var gmap = me.down('gmappanel').getMap();

      var path = google.maps.geometry.encoding.decodePath(record.get('encoded_polyline'));

      var bounds = new google.maps.LatLngBounds();
      for (var i = 0; i < path.length; i++)
        bounds.extend(path[i]);

      poly = new google.maps.Polyline({
        path: path,
        strokeColor: '#FF0000',
        strokeOpacity: 1.0,
        strokeWeight: 3
      });

      poly.setMap(gmap);

      gmap.fitBounds(bounds);
    });
  },
});
