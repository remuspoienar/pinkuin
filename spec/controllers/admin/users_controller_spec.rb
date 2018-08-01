require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do

  let(:user_admin) { instance_double(User) }

  let(:roles_attributes) do
    roles_h          = {
        roles_attributes: [{ name: '', resource_type: '', role_type: '' }]
    }
    permitted_params = ActionController::Parameters.new(roles_h).permit(:roles_attributes)
    permitted_params[:roles_attributes]
  end


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

    let(:users) { [instance_double(User)] }

    before { set_resource_scope(:user, users) }

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user_admin) }

      it 'fetches the users in the scope of the user' do
        subject
        expect(assigns(:users)).to eq users
      end

      it_behaves_like 'a success response'
    end
  end


  describe 'GET #show' do

    subject { get :show, params: { id: user.to_param } }

    let(:user) { instance_double(User) }

    before { allow(User).to receive(:find).and_return(user) }

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user_admin) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:show, :user) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:show, :user) }

        it 'fetches the user' do
          subject
          expect(assigns(:user)).to eq user
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
      before { authenticate_user(user_admin) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:new, :user) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:new, :user) }

        it_behaves_like 'a success response'
      end
    end
  end


  describe 'GET #edit' do

    subject { get :edit, params: { id: user.to_param } }

    let(:user) { instance_double(User) }

    before { allow(User).to receive(:find).and_return(user) }

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user_admin) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:edit, :user) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:edit, :user) }

        it 'fetches the user' do
          subject
          expect(assigns(:user)).to eq user
        end

        it_behaves_like 'a success response'
      end
    end
  end


  describe 'POST #create' do
    subject { post :create, params: { user: user_attributes.merge(roles_attributes: roles_attributes.to_h) } }

    let(:user_attributes) { attributes_for(:user) }

    let(:user) { build_stubbed(:user) }

    before { allow(User).to receive(:new).and_return(user) }

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user_admin) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:create, :user) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:create, :user) }

        it 'skips confirmation and saves the user' do
          expect(user).to receive(:skip_confirmation!).exactly(:once)
          expect(user).to receive(:save).exactly(:once)
          subject
        end

        context 'with successful save' do
          before do
            allow(user).to receive(:save).and_return(true)
            allow(user_admin).to receive(:add_role).and_return(true)
            allow(::UserService::Roles).to receive(:assign).and_return({ success: true })
          end

          context 'with successful assign of roles' do
            it 'calls roles service' do
              expect(::UserService::Roles).to receive(:assign).once.with(user: user, roles: roles_attributes)
              subject
            end

            it 'adds the admin role on the created user to the current user' do
              expect(user_admin).to receive(:add_role).once.with(:admin, user)
              subject
            end

            it 'notifies of success' do
              subject
              expect(flash[:notice]).to eq 'User was successfully created.'
            end

            it 'redirects to the created user' do
              subject
              expect(response).to redirect_to(admin_user_path(user))
            end
          end

          context 'with failed assign of roles' do
            before { allow(::UserService::Roles).to receive(:assign).and_return({ success: false, message: error_message }) }

            let(:error_message) { 'Something went wrong with roles assigning' }

            it 'notifies of failure' do
              subject
              expect(flash[:alert]).to eq error_message
            end

            it 'renders edit' do
              subject
              expect(response).to render_template(:new)
            end
          end
        end

        context 'with failed save' do
          before { allow(user).to receive(:save).and_return(false) }

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
    subject { put :update, params: { id: user.to_param, user: user_attributes.merge(roles_attributes: roles_attributes.to_h) } }

    let(:user_attributes) { attributes_for(:user) }


    let(:user) { build_stubbed(:user) }

    before { allow(User).to receive(:find).and_return(user) }

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user_admin) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:update, :user) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:update, :user) }

        it 'calls update on the user' do
          expect(user).to receive(:update).exactly(:once)
          subject
        end

        context 'with successful update' do
          before do
            allow(user).to receive(:update).and_return(true)
            allow(::UserService::Roles).to receive(:assign).and_return({ success: true })
          end

          context 'with successful assign of roles' do
            it 'calls roles service' do
              expect(::UserService::Roles).to receive(:assign).once.with(user: user, roles: roles_attributes)
              subject
            end

            it 'notifies of success' do
              subject
              expect(flash[:notice]).to eq 'User was successfully updated.'
            end

            it 'redirects to the updated user' do
              subject
              expect(response).to redirect_to(admin_user_path(user))
            end
          end

          context 'with failed assign of roles' do
            before { allow(::UserService::Roles).to receive(:assign).and_return({ success: false, message: error_message }) }

            let(:error_message) { 'Something went wrong with roles assigning' }

            it 'notifies of failure' do
              subject
              expect(flash[:alert]).to eq error_message
            end

            it 'renders edit' do
              subject
              expect(response).to render_template(:edit)
            end
          end
        end

        context 'with failed update' do
          before { allow(user).to receive(:update).and_return(false) }

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

    subject { delete :destroy, params: { id: user.to_param } }

    let(:user) { instance_double(User) }

    before do
      allow(User).to receive(:find).and_return(user)
      allow(user).to receive(:destroy)
    end

    context 'with unauthenticated user' do
      it_behaves_like 'a failure response'
    end

    context 'with authenticated user' do
      before { authenticate_user(user_admin) }

      context 'with unauthorized user' do
        before { fail_authorization_for_action_on_resource(:destroy, :user) }

        it_behaves_like 'a failure response'
      end

      context 'with authorized user' do
        before { authorize_action_on_resource(:destroy, :user) }

        it 'destroys the requested user' do
          expect(user).to receive(:destroy)
          subject
        end

        it 'notifies of success' do
          subject
          expect(flash[:notice]).to eq 'User was successfully deleted.'
        end

        it 'redirects to the users list' do
          subject
          expect(response).to redirect_to(admin_users_url)
        end
      end
    end
  end
end
