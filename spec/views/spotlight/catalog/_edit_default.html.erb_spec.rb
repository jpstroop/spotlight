require 'spec_helper'

describe "spotlight/catalog/_edit_default.html.erb" do
  let(:blacklight_config) { Blacklight::Configuration.new }

  let(:document) { stub_model(::SolrDocument) }

  before do
    view.stub(exhibit_tags_path: "autocomplete-path.json")
    view.stub(blacklight_config: blacklight_config)
    view.stub(current_exhibit: stub_model(Spotlight::Exhibit))
    assign(:document, document)
  end

  it "should have a edit tag form" do
    render
    expect(rendered).to have_field 'solr_document_exhibit_tag_list'
    expect(rendered).to have_selector '#solr_document_exhibit_tag_list[@data-autocomplete_url="autocomplete-path.json"]'
  end
end