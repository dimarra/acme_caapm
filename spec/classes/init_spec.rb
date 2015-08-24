require 'spec_helper'
describe 'acme_caapm' do

  context 'with defaults for all parameters' do
    it { should contain_class('acme_caapm') }
  end
end
