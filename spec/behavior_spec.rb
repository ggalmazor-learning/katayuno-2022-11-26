# frozen_string_literal: true

class NumberSequence
  def next
    rand
  end
end

class FakeNumberSequence
  def initialize(*next_numbers)
    @index = 0
    @next_numbers = next_numbers
  end

  def next
    roll = @next_numbers[@index]
    next_index = (@index + 1) % @next_numbers.size
    @index = next_index
    roll
  end
end

class Friend
  def initialize(name, probability)
    @name = name
    @probability = probability
  end

  def [](index)
    return @name if index == 0

    @probability
  end
end

class PresentGenerator
  def initialize(number_sequence = NumberSequence.new)
    @number_sequence = number_sequence
  end

  def generate(tuples)
      names_that_get_a_scarf = tuples.select do |tuple|
        @number_sequence.next > tuple[1]
      end.map do |tuple|
        tuple[0]
      end
      return 'Hurray! Christmas presents done!' if names_that_get_a_scarf.empty?
      return "#{names_that_get_a_scarf.first} gets a scarf" if names_that_get_a_scarf.size == 1
      return "#{names_that_get_a_scarf.join(' and ')} get a scarf" if names_that_get_a_scarf.size == 2
      *head, tail = names_that_get_a_scarf
      return "#{head.join(', ')} and #{tail} get a scarf"
  end
end

RSpec.describe 'Behavior' do
  context 'given a friend' do
    context 'when the odds of finding a present are 0%' do
      it 'returns "Ana gets a scarf"' do
        expect(PresentGenerator.new.generate([Friend.new('Ana', 0)])).to eq('Ana gets a scarf')
      end
    end

    context 'when the odds of finding a present are 100%' do
      it 'returns "Hurray! Christmas presents done!"' do
        expect(PresentGenerator.new.generate([Friend.new('Ana', 1)])).to eq('Hurray! Christmas presents done!')
      end
    end
    context 'when the odds of finding a present are 70%' do
      context 'and the next random number is below 70' do
        it 'returns "Hurray! Christmas presents done!' do
          expect(PresentGenerator.new(FakeNumberSequence.new(0.6)).generate([['Ana', 0.7]])).to eq('Hurray! Christmas presents done!')
        end
      end
      context 'and the next random number is equal or greater than 70' do
        it 'returns "Ana gets a scarf' do
          expect(PresentGenerator.new(FakeNumberSequence.new(0.8)).generate([['Ana', 0.7]])).to eq('Ana gets a scarf')
        end
      end
    end
  end
  context 'given a set of friends' do
    context 'when the odds of finding a present are 0%' do
      it 'returns "Ana and Joserra get a scarf"' do
        expect(PresentGenerator.new(FakeNumberSequence.new(1)).generate([Friend.new('Ana', 0), Friend.new('Joserra', 0)])).to eq('Ana and Joserra get a scarf')
      end
      context 'when the odds of finding a present are 70%' do
        it 'returns "Ana" gets a scarf' do
          expect(PresentGenerator.new(FakeNumberSequence.new(1, 0)).generate([Friend.new('Ana', 0), Friend.new('Joserra', 0)])).to eq('Ana gets a scarf')
        end
      end
      context 'when the odds of finding a present are 70%' do
        it 'returns "Ana, Joserra and Gonzalo" get a scarf' do
          expect(PresentGenerator.new(FakeNumberSequence.new(1)).generate([Friend.new('Ana', 0), Friend.new('Joserra', 0), Friend.new('Gonzalo', 0)])).to eq('Ana, Joserra and Gonzalo get a scarf')
        end
      end
    end

    context 'when the odds of finding a present are 100%' do
      it 'returns "Hurray! Christmas presents done!' do
        expect(PresentGenerator.new(FakeNumberSequence.new(1)).generate([Friend.new('Ana', 1), Friend.new('Joserra', 1)])).to eq('Hurray! Christmas presents done!')
      end
    end
  end
end
