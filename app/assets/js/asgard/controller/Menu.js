/*
 * Copyright (C) 2012-2012, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Asgard.controller.Menu', {
  extend: 'Asgard.Plugin',
  requires: [
  ],

  css: '/assets/flarc-asgard.css',

  stores: [ ],
  views: [ ],

  init: function() {
    var me = this;

    me.callParent(arguments);

    me.control({
      'viewport > tabpanel > panel[name=menu] button': { click: me.onMenuButton },

      'viewport > tabpanel > panel[klass=Asgard.Flarc.Flight.IndexPanel] > panel > toolbar button[name=new]':
       { click: function() { me.openUri('flarc/flights/new'); } },

      'viewport > tabpanel > panel[klass=Asgard.Flarc.Plane.IndexPanel] > panel > toolbar button[name=new]':
       { click: function() { me.openUri('flarc/planes/new'); } },

      'viewport > tabpanel > panel[klass=Asgard.Flarc.PlaneType.IndexPanel] > panel > toolbar button[name=new]':
       { click: function() { me.openUri('flarc/plane_types/new'); } },
    });
  },

  onMenuButton: function(button) {
    var me = this;

    if (button.name == 'flights')
      me.openUri('flarc/flights/');
    else if (button.name == 'planes')
      me.openUri('flarc/planes/');
    else if (button.name == 'plane_types')
      me.openUri('flarc/plane_types/');
    else if (button.name == 'championships')
      me.openUri('flarc/championships/');
    else if (button.name == 'pilots')
      me.openUri('flarc/pilots/');
    else if (button.name == 'regenerate_rankings') {
      button.setLoading('Requesting...');
      Asgard.AjaxJson.request({
        url: '/flarc/rankings/regenerate',
        method: 'POST',
        jsonData: { },
        callback: function() { button.setLoading(false); },
        success: function() {
          Ext.Msg.alert('Done', 'Rankings updated');
        },
        failure: Asgard.ExceptionWindow.ajaxFailure,
      });
    }
  },
});
