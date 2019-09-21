require 'spec_helper'

describe 'Mf2HasValidHentry' do
  let(:valid_filename) { './public/mf2/c0bb6cff-fc03-42d1-87d0-d817ad2f550f/index.html' }

  validators = [
    BookmarksHaveValidHentry,
    LikesHaveValidHentry,
    RepliesHaveValidHentry,
    RepostsHaveValidHentry,
    RsvpsHaveValidHentry,
    NotesHaveValidHentry,
  ]

  context 'delegates' do
    before :each do
      validators.each do |clazz|
        allow_any_instance_of(clazz).to receive(:validate)
          .and_return false
      end
    end

    validators.each do |clazz|
      it "to #{clazz.to_s}" do
        # given
        html = Nokogiri::HTML(File.read('spec/fixtures/like/valid.html'))
        sut = Mf2HasValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(clazz).to receive(:validate)
          .with(anything)
          .and_return true

        # when
        sut.run

        # then
        expect(sut.issues.length).to eq 0
      end

      it "errors if #{clazz.to_s} errors" do
        # given
        html = Nokogiri::HTML(File.read('spec/fixtures/like/valid.html'))
        sut = Mf2HasValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(clazz).to receive(:validate)
          .with(anything)
            .and_raise InvalidMetadataError, 'Bar'
          expect(sut).to receive(:add_issue)
            .with('Bar')
            .and_call_original

        # when
        sut.run

        # then
        expect(sut.issues.length).to eq 1
      end
    end
  end

  it 'returns if it receives a successful validation' do
    # given
    html = Nokogiri::HTML(File.read('spec/fixtures/like/valid.html'))
    sut = Mf2HasValidHentry.new('', valid_filename, html, {})

    expect_any_instance_of(BookmarksHaveValidHentry).to receive(:validate)
      .with(anything)
      .and_return true

    expect_any_instance_of(LikesHaveValidHentry).to_not receive(:validate)

    # when
    sut.run

    expect(sut.issues.length).to eq 0
  end

  context 'when not on an MF2 page' do
    it 'skips' do
      # given
      html = Nokogiri::HTML(File.read('spec/fixtures/like/valid.html'))
      sut = Mf2HasValidHentry.new('', './public/mf3/c0bb6cff-fc03-42d1-87d0-d817ad2f550f/index.html' , html, {})

      # when
      sut.run

      # then
      expect(sut.issues.length).to eq 0
    end
  end

  context 'when no `h-entry`' do
    it 'skips' do
      # given
      html = Nokogiri::HTML(File.read('spec/fixtures/measure.html'))
      sut = Mf2HasValidHentry.new('', valid_filename, html, {})

      # when
      sut.run

      # then
      expect(sut.issues.length).to eq 0
    end

    pending 'validates it'
  end

  context 'which is an alias page' do
    let(:html) { Nokogiri::HTML(File.read('spec/fixtures/post_hugo_alias.html')) }
    let(:sut) { Mf2HasValidHentry.new('', './public/mf2/c0bb6cff-fc03-42d1-87d0-d817ad2f550f/index.html', html, {})}

    it 'skips' do
      expect(sut).to_not receive(:add_issue)

      sut.run
    end
  end
end
