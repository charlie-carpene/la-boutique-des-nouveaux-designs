require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it 'flash_class(type) should return the right bootstrap class to style notice' do
    expect(helper.flash_class("notice")).to eq("alert alert-info")
    expect(helper.flash_class("success")).to eq("alert alert-success")
    expect(helper.flash_class("error")).to eq("alert alert-danger")
    expect(helper.flash_class("alert")).to eq("alert alert-danger")
    expect(helper.flash_class("blabla")).to eq("alert alert-primary")
  end

  it 'translate_mounth() should return the right month' do
    expect(helper.translate_month(1)).to eq("Janvier")
    expect(helper.translate_month(2)).to eq("Février")
    expect(helper.translate_month(3)).to eq("Mars")
    expect(helper.translate_month(4)).to eq("Avril")
    expect(helper.translate_month(5)).to eq("Mai")
    expect(helper.translate_month(6)).to eq("Juin")
    expect(helper.translate_month(7)).to eq("Juillet")
    expect(helper.translate_month(8)).to eq("Août")
    expect(helper.translate_month(9)).to eq("Septembre")
    expect(helper.translate_month(10)).to eq("Octobre")
    expect(helper.translate_month(11)).to eq("Novembre")
    expect(helper.translate_month(12)).to eq("Décembre")
    expect(helper.translate_month(13)).to eq("Mois inexistant")
  end

  it 'encrypt and decrypt data while assigning a purpose' do
    data = helper.encrypt_data("blabla", "just saying")
    
    expect(data).to be_kind_of(String)
    expect(helper.decrypt_data(data, "just saying")).to eq("blabla")
  end
end
