/*
 * Copyright (C) 2008-2012, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Asgard.Flarc.Pilot.IndexPanel', {
  extend: 'Asgard.index.GridPanelBase',
  requires: [
    'Asgard.Core.Plugin',
    'Flarc.Pilot'
  ],

  title: 'People',
  model: 'Flarc.Pilot',
  columns: [
   {
    text: 'Handle',
    dataIndex: 'handle',
    filterable: true,
    searchable: true,
   },
   {
    text: 'Name',
    searchIn: [ 'first_name', 'last_name' ], // Temporary until we also decouple search form actual record schema
    tpl: '{name.first} {name.last}',
    xtype: 'stringtemplatecolumn',
    flex: 1,
    filterable: true,
    searchable: true,
   },
   {
    text: 'Italian fiscal code',
    dataIndex: 'italian_fiscal_code',
    filterable: true,
    searchable: true,
    width: 130,
   },
  ],
  actions: [
   {
    text: 'New...',
    name: 'new',
   },
  ],

  initComponent: function() {
    var me = this;

    me.callParent(arguments);

    var toolbar = me.child('toolbar');
  },
});
