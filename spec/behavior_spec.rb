# frozen_string_literal: true

def presentGenerator(_name, probability)
  return true if probability == 1

  false
end

RSpec.describe 'Behavior' do
  context 'given a friend' do
    context 'when the odds of finding a present are 0%' do
      it 'returns false ' do
        expect(presentGenerator('Ana', 0)).to eq(false)
      end
    end

    context 'when the odds of finding a present are 100%' do
      it 'returns true' do
        expect(presentGenerator('Ana', 1)).to eq(true)
      end
    end
  end
end
