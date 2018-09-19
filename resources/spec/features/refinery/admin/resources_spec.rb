# frozen_string_literal: true

require 'spec_helper'

module Refinery
  module Admin
    describe 'Resources', type: :feature do
      refinery_login

      context 'when no files' do
        it 'invites to upload file' do
          visit refinery.admin_resources_path
          expect(page).to have_content('There are no files yet. Click "Upload new file" to add your first file.')
        end
      end

      it 'shows upload file link' do
        visit refinery.admin_resources_path
        expect(page).to have_content('Upload new file')
        expect(page).to have_selector('a[href*="/refinery/resources/new"]')
      end

      context 'new/create' do
        let(:uploading_a_file) do
          lambda do
            visit refinery.admin_resources_path
            find('a', text: 'Upload new file').click

            expect(page).to have_selector 'iframe#dialog_iframe'

            page.within_frame('dialog_iframe') do
              attach_file 'resource_file', file_path
              click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')
            end
          end
        end

        context 'when the file mime_type is acceptable' do
          let(:file_path) { Refinery.roots('refinery/resources').join('spec/fixtures/cape-town-tide-table.pdf') }

          it 'the file is uploaded', js: true do
            expect(uploading_a_file).to change(Refinery::Resource, :count).by(1)
          end
        end

        context 'when the file mime_type is not acceptable' do
          let(:file_path) { Refinery.roots('refinery/resources').join('spec/fixtures/refinery_is_secure.txt') }

          it 'the file is rejected', js: true do
            expect(uploading_a_file).to_not change(Refinery::Resource, :count)

            page.within_frame('dialog_iframe') do
              expect(page).to have_content(::I18n.t('incorrect_format', scope: 'activerecord.errors.models.refinery/resource'))
            end
          end
        end

        describe 'max file size' do
          before do
            allow(Refinery::Resources).to receive(:max_file_size).and_return('1224')
          end

          context 'in english' do
            before do
              allow(Refinery::I18n).to receive(:current_locale).and_return(:en)
            end

            it 'is shown' do
              visit refinery.admin_resources_path
              click_link 'Upload new file'

              within('#file') do
                expect(page).to have_selector('a[tooltip="The maximum file size is 1.2 KB."]')
              end
            end
          end

          context 'in danish' do
            before do
              allow(Refinery::I18n).to receive(:current_locale).and_return(:da)
            end

            it 'is shown' do
              visit refinery.admin_resources_path

              click_link 'Tilføj en ny fil'
              within '#file' do
                expect(page).to have_selector('a[tooltip="Filen må maksimalt fylde 1,2 KB."]')
              end
            end
          end
        end
      end

      context 'edit/update' do
        let!(:resource) { FactoryBot.create(:resource) }

        it 'updates file' do
          visit refinery.admin_resources_path
          expect(page).to have_content('Cape Town Tide Table')
          expect(page).to have_selector("a[href='/refinery/resources/#{resource.id}/edit']")

          click_link 'Edit this file'

          expect(page).to have_content('Cape Town Tide Table or replace it with this one...')
          expect(page).to have_selector("a[href*='/refinery/resources']")

          attach_file 'resource_file', Refinery.roots('refinery/resources').join('spec/fixtures/cape-town-tide-table2.pdf')
          click_button 'Save'

          expect(page).to have_content('Cape Town Tide Table2')
          expect(Refinery::Resource.count).to eq(1)
        end

        describe 'translate' do
          before do
            allow(Refinery::I18n).to receive(:frontend_locales).and_return(%i[en fr])
          end

          it 'can have a second locale added to it' do
            visit refinery.admin_resources_path
            expect(page).to have_content('Cape Town Tide Table')
            expect(page).to have_selector("a[href='/refinery/resources/#{resource.id}/edit']")

            click_link 'Edit this file'

            within '#switch_locale_picker' do
              click_link 'FR'
            end

            fill_in 'Title', with: 'Premier fichier'
            click_button 'Save'

            expect(page).to have_content("'Premier fichier' was successfully updated.")
            expect(Resource::Translation.count).to eq(1)
          end
        end
      end

      context 'destroy' do
        let!(:resource) { FactoryBot.create(:resource) }

        it 'removes file' do
          visit refinery.admin_resources_path
          expect(page).to have_selector("a[href='/refinery/resources/#{resource.id}']")

          click_link 'Remove this file forever'

          expect(page).to have_content("'Cape Town Tide Table' was successfully removed.")
          expect(Refinery::Resource.count).to eq(0)
        end
      end

      context 'download' do
        let!(:resource) { FactoryBot.create(:resource) }

        it 'succeeds' do
          visit refinery.admin_resources_path

          click_link 'Download this file'

          expect(page.body[0, 4]).to eq('%PDF')
        end

        context 'when the extension is mounted with a named space' do
          before do
            Rails.application.routes.draw do
              mount Refinery::Core::Engine, at: '/about'
            end
            Rails.application.routes_reloader.reload!
          end

          after do
            Rails.application.routes.draw do
              mount Refinery::Core::Engine, at: '/'
            end
          end

          it 'succeeds' do
            visit refinery.admin_resources_path

            click_link 'Download this file'

            expect(page.body[0, 4]).to eq('%PDF')
          end
        end
      end
    end
  end
end
