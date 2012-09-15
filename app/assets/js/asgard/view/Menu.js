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

Ext.define('Asgard.view.Menu', {
  extend: 'Ext.panel.Panel',
  requires: [
  ],
  layout: 'border',
  title: 'MENU',
  items: [
   {
    xtype: 'container',
    region: 'east',
    width: 600,
    layout: {
      type: 'vbox',
      align: 'stretch',
    },
    items: [
// PENDING FLIGHTS


//     {
//      xtype: 'dsl_migrations_menuwidget',
//      flex: 1,
//     },
    ],
   },
   {
    xtype: 'container',
    region: 'center',
    layout: {
      type: 'table',
      columns: 4,
      tableAttrs: {
        style: {
          width: '100%',
          height: '100%',
          'text-align': 'center'
        }
      }
    },
    defaultType: 'button',
    defaults: {
      iconAlign: 'top',
      width: 110,
      height: 130, // TODO: Make button sizes adapt to viewport's size
      scale: 'large',
      cls: 'menubutton',
    },
    items: [
     {
      text: 'Voli',
      symbol: 'flights',
      icon: '/assets/flarc/flight_100x100.png',
     },
     {
      text: 'Alianti',
      symbol: 'planes',
      icon: '/assets/flarc/glider_100x100.png',
     },
     {
      text: 'Tipi',
      symbol: 'plane_types',
      icon: '/assets/flarc/glider_100x100.png',
     },
     {
      text: 'Pilots',
      symbol: 'pilots',
      icon: '/assets/core/person_100x100.png',
     },
     {
      text: 'Championships',
      symbol: 'championships',
//      icon: '',
     },
     {
      text: '',
      symbol: '',
//      icon: '',
     },
     {
      text: '',
      symbol: '',
//      icon: '',
     },
     {
      text: '',
      symbol: '',
//      icon: '',
     },
    ]
   },

  ],
});

