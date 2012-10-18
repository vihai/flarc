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

Ext.define('Asgard.Flarc.Championship.Flight.CollectionField', {
  extend: 'Asgard.form.field.CollectionView',
  requires: [
    'Asgard.Flarc.Plugin',
    'Asgard.PolymorphicView',
    'Flarc.Championship',
    'Asgard.Flarc.Championship.Flight.Cid2011.Form',
    'Asgard.Flarc.Championship.Flight.Cid2012.Form',
    'Asgard.Flarc.Championship.Flight.Csvva2009.Form',
    'Asgard.Flarc.Championship.Flight.Csvva2010.Form',
    'Asgard.Flarc.Championship.Flight.Csvva2011.Form',
  ],
  alias: 'widget.flarc_championshipflights',

  model: 'Flarc.Championship.Flight',

  dataview: {
    xtype: 'polyview',
    multiSelect: true,
    perTypeTpl: {
      null: [
        '<b>{_type}</b><br />',
        '{distance / 1000} km - {points:number("0,000")} points',
        '<span style="float: right">{status}</span>',
      ],
      'Flarc::Championship::Flight::Csvva2009': [
        '<b>CSVVA 2009</b><br />',
        '{distance / 1000} km - {points:number("0,000")} points',
        '<span style="float: right">{status}</span>',
      ],
      'Flarc::Championship::Flight::Csvva2010': [
        '<b>CSVVA 2010</b><br />',
        '{distance / 1000} km - {points:number("0,000")} points',
        '<span style="float: right">{status}</span>',
      ],
      'Flarc::Championship::Flight::Csvva2011': [
        '<b>CSVVA 2011</b><br />',
        '{distance / 1000} km - {points:number("0,000")} points',
        '<span style="float: right">{status}</span>',
      ],
      'Flarc::Championship::Flight::Cid2011': [
        '<b>CID 2011</b> - {cid_ranking}<br />',
        '{cid_task_type} - {cid_task_eval} - {distance / 1000} km - {points:number("0,000")} points',
        '<span style="float: right">{status}</span>',
      ],
      'Flarc::Championship::Flight::Cid2012': [
        '<b>CID 2012</b> - {cid_ranking}<br />',
        '{cid_task_type} - {cid_task_eval} - {distance / 1000} km - {points:number("0,000")} points',
        '<span style="float: right">{status}</span>',
      ],
    },

    store: {
      model: 'Flarc.Championship.Flight',
    },
  },

  enableBuiltinAddButton: false,
  toolbarItems: [
   {
    icon: '/assets/add.png',
    text: 'Add',
    menu: {
      items: [
        { text: 'CID 2012', name: 'add-cid2012' },
      ]
    }
   },
  ],

  getFormForRecord: function(record, opts) {
    var formClass = opts ? opts.formClass : null;

    if (record) {
      var forms = {
        'Flarc::Championship::Flight::Csvva2009': 'Asgard.Flarc.Championship.Flight.Csvva2009.Form',
        'Flarc::Championship::Flight::Csvva2010': 'Asgard.Flarc.Championship.Flight.Csvva2010.Form',
        'Flarc::Championship::Flight::Csvva2011': 'Asgard.Flarc.Championship.Flight.Csvva2011.Form',
        'Flarc::Championship::Flight::Cid2011': 'Asgard.Flarc.Championship.Flight.Cid2011.Form',
        'Flarc::Championship::Flight::Cid2012': 'Asgard.Flarc.Championship.Flight.Cid2012.Form',
      };

      formClass = forms[record.get('_type')];
    }

    return Ext.create(formClass, {
      standalone: false,
      frame: false,
      border: false,
      buttons: [
       { text: 'Ok', name: 'ok' },
       { text: 'Cancel', name: 'cancel' },
      ]
    });
  },

  initComponent: function() {
    var me = this;

    me.callParent(arguments);

    me.toolbar.down('menuitem[name=add-cid2012]').on('click', function() {
      me.onAddRecord({ formClass: 'Asgard.Flarc.Championship.Flight.Cid2012.Form' });
    });
  },

});
