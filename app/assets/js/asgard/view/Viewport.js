/*
 * Yggdra Core
 *
 * Copyright (C) 2008-2011, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Asgard.view.Viewport', {
  extend: 'Ext.container.Viewport',
  requires: [ 'Asgard.Notification', 'Ext.data.proxy.Rest' ],
  layout: 'border',
  items: [
   {
    xtype: 'toolbar',
    region: 'north',
    height: 30,
    border: false,
    items: [
      'Yggdra', '->',
     {
      text: 'Logout',
      name: 'logout',
      icon: '/assets/exit.png',
     },
    ],
   },
   {
    xtype: 'treepanel',
    name: 'menu_tree',
    region: 'west',
    title: 'Menu',
    width: 230,
    layout: 'fit',
    collapsible: true,
    collapsed: true,
    autoScroll: true,
    rootVisible: false,
    lines: false,
    store: {
      fields: [ 'text', 'iconCls', 'children', 'leaf', 'uri', 'panel_plugin', 'panel_class' ],
      proxy: {
        type: 'ajax',
        url: '/asgard/menu_tree',
        reader: 'json',
      },
      autoLoad: true,
    },
   },

   {
    xtype: 'tabpanel',
    region: 'center',
    activeTab: 0,
    items: [
     {
      title: 'MENU',
      id: 'menu',
      name: 'menu',
      uri: 'menu',
      closable: false,
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
        width: 100, height: 100 // TODO: Make button sizes adapt to viewport's size
      },
      items: [
       {
        text: 'Voli',
        symbol: '',
//        icon: '/assets/shop/agreements_button.png',
       },
       {
        text: 'Piloti',
        symbol: '',
//        icon: '',
       },
       {
        text: 'Alianti',
        symbol: '',
//        icon: '',
       },
       {
        text: 'Tipi di aliante',
        symbol: '',
//        icon: '',
       },
       {
        text: '',
        symbol: '',
//        icon: '',
       },
       {
        text: '',
        symbol: '',
//        icon: '',
       },
       {
        text: '',
        symbol: '',
//        icon: '',
       },
       {
        text: '',
        symbol: '',
//        icon: '',
       },
      ]
     },
    ],
   },
  ]
});
