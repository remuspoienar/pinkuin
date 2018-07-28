require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  let(:user) { instance_double(User) }

  shared_examples 'a failure response' do
    it 'returns a failure response' do
      subject
      expect(response).to_not be_success
    end
  end

  shared_examples 'a success response' do
    it 'returns a success response' do
      subject
      expect(response).to be_success
    end
  end

  describe 'GET #index' do

    subject { get :index }

    let(:projects) { [instance_double(Project)] }

    before { set_resource_scope(:project, projects) }

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user) }

      it 'fetches the projects in the scope of the user' do
        subject
        expect(assigns(:projects)).to eq projects
      end

      it_behaves_like 'a success response'
    end
  end


  describe 'GET #show' do

    subject { get :show, params: { id: project.to_param } }

    let(:project) { instance_double(Project) }

    before { allow(Project).to receive(:find).and_return(project) }

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:show, :project) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:show, :project) }

        it 'fetches the project' do
          subject
          expect(assigns(:project)).to eq project
        end

        it_behaves_like 'a success response'
      end
    end
  end


  describe 'GET #new' do

    subject { get :new }

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:new, :project) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:new, :project) }

        it_behaves_like 'a success response'
      end
    end
  end


  describe 'GET #edit' do

    subject { get :edit, params: { id: project.to_param } }

    let(:project) { instance_double(Project) }

    before { allow(Project).to receive(:find).and_return(project) }

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:edit, :project) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:edit, :project) }

        it 'fetches the project' do
          subject
          expect(assigns(:project)).to eq project
        end

        it_behaves_like 'a success response'
      end
    end
  end


  describe 'POST #create' do
    subject { post :create, params: { project: project_attributes } }

    let(:project_attributes) { attributes_for(:project) }


    let(:project) { build_stubbed(:project) }

    before { allow(Project).to receive(:new).and_return(project) }

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:create, :project) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:create, :project) }

        it 'calls save on the project' do
          expect(project).to receive(:save).exactly(:once)
          subject
        end

        context 'with successful save' do
          before { allow(project).to receive(:save).and_return(true) }

          it 'notifies of success' do
            subject
            expect(flash[:notice]).to eq 'Project was successfully created.'
          end

          it 'redirects to the created project' do
            subject
            expect(response).to redirect_to(project)
          end
        end

        context 'with failed save' do
          before { allow(project).to receive(:save).and_return(false) }

          it 'returns a success response (i.e. to display the "new" template)' do
            subject
            expect(response).to be_success
          end

          it 'renders new' do
            subject
            expect(response).to render_template(:new)
          end
        end
      end
    end
  end


  describe 'PUT #update' do
    subject { put :update, params: { id: project.to_param, project: project_attributes } }

    let(:project_attributes) { attributes_for(:project) }


    let(:project) { build_stubbed(:project) }

    before { allow(Project).to receive(:find).and_return(project) }

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:update, :project) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:update, :project) }

        it 'calls update on the project' do
          expect(project).to receive(:update).exactly(:once)
          subject
        end

        context 'with successful update' do
          before { allow(project).to receive(:update).and_return(true) }

          it 'notifies of success' do
            subject
            expect(flash[:notice]).to eq 'Project was successfully updated.'
          end

          it 'redirects to the updated project' do
            subject
            expect(response).to redirect_to(project)
          end
        end

        context 'with failed update' do
          before { allow(project).to receive(:update).and_return(false) }

          it 'returns a success response (i.e. to display the "edit" template)' do
            subject
            expect(response).to be_success
          end

          it 'renders edit' do
            subject
            expect(response).to render_template(:edit)
          end
        end
      end
    end
  end


  describe 'DELETE #destroy' do

    subject { delete :destroy, params: { id: project.to_param } }

    let(:project) { instance_double(Project) }

    before do
      allow(Project).to receive(:find).and_return(project)
      allow(project).to receive(:destroy)
    end

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:destroy, :project) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:destroy, :project) }

        it 'destroys the requested project' do
          expect(project).to receive(:destroy)
          subject
        end

        it 'notifies of success' do
          subject
          expect(flash[:notice]).to eq 'Project was successfully deleted.'
        end

        it 'redirects to the projects list' do
          subject
          expect(response).to redirect_to(projects_url)
        end
      end
    end
  end
end
