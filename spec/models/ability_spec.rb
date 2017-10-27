require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  describe 'abilities of loggined user' do
    let(:user) { create(:user) }
    let(:ability) { Ability.new(user) }
    let(:project) { create(:project, user: user) }

    subject { ability }

    context 'for projects' do
      let(:other_project) { create(:project) }

      it { expect(ability).to be_able_to(:create, Project) }
      it { expect(ability).to be_able_to(:all, project) }

      it { expect(ability).not_to be_able_to(:read, other_project) }
      it { expect(ability).not_to be_able_to(:update, other_project) }
      it { expect(ability).not_to be_able_to(:destroy, other_project) }
    end

    context 'for tasks' do
      let(:task) { create(:task, project: project) }
      let(:other_task) { create(:task) }

      it { expect(ability).to be_able_to(:create, Task) }
      it { expect(ability).to be_able_to(:all, task) }

      it { expect(ability).not_to be_able_to(:read, other_task) }
      it { expect(ability).not_to be_able_to(:update, other_task) }
      it { expect(ability).not_to be_able_to(:destroy, other_task) }
    end

    context 'for comments' do
      let(:task) { create(:task, project: project) }
      let(:comment) { create(:comment, task: task) }
      let(:other_comment) { create(:comment) }

      it { expect(ability).to be_able_to(:create, Comment) }
      it { expect(ability).to be_able_to(:all, comment) }

      it { expect(ability).not_to be_able_to(:read, other_comment) }
      it { expect(ability).not_to be_able_to(:update, other_comment) }
      it { expect(ability).not_to be_able_to(:destroy, other_comment) }
    end
  end
end
