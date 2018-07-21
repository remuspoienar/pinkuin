require 'rails_helper'

describe ProjectsController, type: :controller do

  let(:user) { create(:user) }

  describe 'GET #index' do

    subject { get :index }

    let!(:projects) { create_list(:project, 2) }

    context 'with unauthenticated user' do
      it 'returns a failure response' do
        subject
        expect(response).to_not be_success
      end
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'with unauthorized user' do
        it 'returns a failure response' do
          subject
          expect(response).to_not be_success
        end
      end

      context 'with authorized user' do
        # if user is the author then he should see the projects
        let!(:projects) { create_list(:project, 2, author: user) }

        it 'returns a success response' do
          subject
          expect(response).to be_success
        end
      end

    end


  end

  describe 'GET #show' do

    subject { get :show, params: { id: project.id } }

    let(:project) { create(:project) }

    context 'with unauthenticated user' do
      it 'returns a failure response' do
        subject
        expect(response).to_not be_success
      end
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'with unauthorized user' do
        it 'returns a failure response' do
          subject
          expect(response).to_not be_success
        end
      end

      context 'with authorized user' do
        # if user is author then he can be 'show'ed the project
        let(:project) { create(:project, author: user) }

        it 'returns a success response' do
          subject
          expect(response).to be_success
        end
      end

    end

  end

  describe 'GET #new' do

    subject { get :new }

    context 'with unauthenticated user' do
      it 'returns a failure response' do
        subject
        expect(response).to_not be_success
      end
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'with unauthorized user' do
        it 'returns a failure response' do
          subject
          expect(response).to_not be_success
        end
      end

      context 'with authorized user' do
        before { user.add_role(:create, Project) }

        it 'returns a success response' do
          subject
          expect(response).to be_success
        end
      end

    end


  end

  describe 'GET #edit' do

    subject { get :edit, params: { id: project.id } }

    let(:project) { create(:project) }

    context 'with unauthenticated user' do
      it 'returns a failure response' do
        subject
        expect(response).to_not be_success
      end
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'with unauthorized user' do
        it 'returns a failure response' do
          subject
          expect(response).to_not be_success
        end
      end

      context 'with authorized user' do
        # if user is author then he can be 'show'ed the project
        let(:project) { create(:project, author: user) }

        it 'returns a success response' do
          subject
          expect(response).to be_success
        end
      end

    end

  end

  describe 'POST #create' do
    subject { post :create, params: { project: project_attributes } }

    let(:project_attributes) { attributes_for(:project).merge(author_id: user.id) }

    context 'with unauthenticated user' do
      it 'returns a failure response' do
        subject
        expect(response).to_not be_success
      end
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'with unauthorized user' do
        it 'returns a failure response' do
          subject
          expect(response).to_not be_success
        end
      end

      context 'with authorized user' do
        before { user.add_role(:create, Project) }

        context 'with valid params' do
          it 'creates a new Project' do
            expect { subject }.to change(Project, :count).by(1)
          end

          it 'redirects to the created project' do
            subject
            expect(response).to redirect_to(Project.last)
          end
        end

        context 'with invalid params' do
          let(:project_attributes) { attributes_for(:project).except(:name) }

          it 'returns a success response (i.e. to display the "new" template)' do
            subject
            expect(response).to be_success
          end

          it 'renders new' do
            expect(controller).to receive(:render).once.with(:new)
            subject
          end
        end
      end
    end
  end


  describe 'PUT #update' do
    subject { put :update, params: { id: project.id, project: project_attributes } }

    let!(:project) { create(:project) }
    let(:project_attributes) { attributes_for(:project) }

    context 'with unauthenticated user' do
      it 'returns a failure response' do
        subject
        expect(response).to_not be_success
      end
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'with unauthorized user' do
        it 'returns a failure response' do
          subject
          expect(response).to_not be_success
        end
      end

      context 'with authorized user' do
        # if user is author then he can be 'update' the project
        let!(:project) { create(:project, author: user) }

        context 'with valid params' do
          it 'updates the project' do
            expect { subject }.to change { project.reload.attributes }
          end

          it 'redirects to the updated project' do
            subject
            expect(response).to redirect_to(project)
          end
        end

        context 'with invalid params' do
          let(:project_attributes) { attributes_for(:project).merge(name: 'short') }

          it 'returns a success response (i.e. to display the "edit" template)' do
            subject
            expect(response).to be_success
          end

          it 'renders edit' do
            expect(controller).to receive(:render).once.with(:edit)
            subject
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do

    subject { delete :destroy, params: { id: project.id } }

    let!(:project) { create(:project) }

    context 'with unauthenticated user' do
      it 'returns a failure response' do
        subject
        expect(response).to_not be_success
      end
    end

    context 'with authenticated user' do
      before { sign_in(user) }

      context 'with unauthorized user' do
        it 'returns a failure response' do
          subject
          expect(response).to_not be_success
        end
      end

      context 'with authorized user' do
        # if user is author then he can be destroy the project
        let(:project) { create(:project, author: user) }

        it 'destroys the requested project' do
          expect { subject }.to change(Project, :count).by(-1)
        end

        it 'redirects to the projects list' do
          subject
          expect(response).to redirect_to(projects_url)
        end
      end
    end
  end
end
