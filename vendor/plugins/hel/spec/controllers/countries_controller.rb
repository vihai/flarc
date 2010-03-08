require File.dirname(__FILE__) + '/../spec_helper'
require 'pp'


describe 'simple mock', :shared => true do
  before( :each ) do
    #@country = mock_model(Hel::Country, :name => 'Beatitonia', :a2 => 'XX', :a3 => 'XXX', :num => 1)
    @country = stub_model(Hel::Country, :id=>1, :name => 'Beatitonia', :a2 => 'XX', :a3 => 'XXX', :num => 1)

    Hel::Country.stub!(:find).and_return(@country)
  end
end



#-html

describe CountriesController, ' HTML ' do
  it_should_behave_like 'simple mock'
  
  it 'should list all the countries with GET' do    
    get :index
    response.headers['type'].should == 'text/html; charset=utf-8'
    response.should be_success
  end

  it 'should find the country with GET' do    
    get :show, :id => 1, :format => 'html'
    response.headers['type'].should == 'text/html; charset=utf-8'
    response.should be_success
  end

  it 'should request the country for editing with GET' do    
    get :edit, :id => 1, :format => 'html'
    response.headers['type'].should == 'text/html; charset=utf-8'
    response.should be_success
  end

end



#-xml

describe CountriesController, ' XML ' do
  it_should_behave_like 'simple mock'
    
  it 'should find the country with GET' do    
    get :show, :id => 1, :format => 'xml'
    response.headers['type'].should == 'application/xml; charset=utf-8'
    response.should be_success
  end

  it 'should list all the countries with GET' do    
    get :index, :format => 'xml'
    response.headers['type'].should == 'application/xml; charset=utf-8'
    response.should be_success
  end
  
  it 'should update the country for editing with PUT' do    
    # vorrei alzare l'errore ...
    put :show, :id=> 1, :hel_country =>{'name'=>nil, 'a2'=>'06', 'num'=>'100006', 'a3'=>'006'} , :format => 'xml'
    puts response.inspect
    response.headers['type'].should == 'application/xml; charset=utf-8'
    response.should be_success
  end
end



#-json

describe CountriesController, ' JSON ' do
  it_should_behave_like 'simple mock'
    
  it 'should list all the countries with GET' do    
    get :index, :format => 'json'
    response.headers['type'].should == 'application/json; charset=utf-8'
    response.should be_success
  end

  it 'should find the country with GET' do    
    get :show, :id => 1, :format => 'json'
    response.headers['type'].should == 'application/json; charset=utf-8'
    response.should be_success
  end

end



#-yaml

describe CountriesController, ' YAML ' do
  it_should_behave_like 'simple mock'

  it 'should list all the countries with GET' do    
    get :index, :format => 'yaml'
    response.headers['type'].should == 'application/x-yaml; charset=utf-8'
    response.should be_success
  end

  it 'should find the country with GET' do    
    get :show, :id => 1, :format => 'yaml'
    response.headers['type'].should == 'application/x-yaml; charset=utf-8'
    response.should be_success
  end

end

