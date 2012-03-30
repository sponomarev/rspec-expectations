require 'spec_helper'

describe "yield matchers" do
  # these helpers are prefixed with an underscore to prevent
  # collisions with the matchers (some of which have the same names)
  def _dont_yield
  end

  def _yield_with_no_args
    yield
  end

  def _yield_with_args(*args)
    yield *args
  end

  describe "expect {...}.to yield_control" do
    it 'passes if the block yields, regardless of the number of yielded arguments' do
      expect { |b| _yield_with_no_args(&b) }.to yield_control
      expect { |b| _yield_with_args(1, 2, &b) }.to yield_control
    end

    it 'fails if the block does not yield' do
      expect {
        expect { |b| _dont_yield(&b) }.to yield_control
      }.to fail_with(/expected given block to yield control/)
    end
  end

  describe "expect {...}.not_to yield_control" do
    it 'passes if the block does not yield' do
      expect { |b| _dont_yield(&b) }.not_to yield_control
    end

    it 'fails if the block does yield' do
      expect {
        expect { |b| _yield_with_no_args(&b) }.not_to yield_control
      }.to fail_with(/expected given block not to yield control/)
    end
  end

  describe "expect {...}.to yield_with_no_args" do
    it 'passes if the block yields with no args' do
      expect { |b| _yield_with_no_args(&b) }.to yield_with_no_args
    end

    it 'fails if the block does not yield' do
      expect {
        expect { |b| _dont_yield(&b) }.to yield_with_no_args
      }.to fail_with(/expected given block to yield with no arguments, but did not yield/)
    end

    it 'fails if the block yeilds with args' do
      expect {
        expect { |b| _yield_with_args(1, &b) }.to yield_with_no_args
      }.to fail_with(/expected given block to yield with no arguments, but yielded with arguments/)
    end
  end

  describe "expect {...}.not_to yield_with_no_args" do
    it "passes if the block does not yield" do
      expect { |b| _dont_yield(&b) }.not_to yield_with_no_args
    end

    it "passes if the block yields with args" do
      expect { |b| _yield_with_args(1, &b) }.not_to yield_with_no_args
    end

    it "fails if the block yields with no args" do
      expect {
        expect { |b| _yield_with_no_args(&b) }.not_to yield_with_no_args
      }.to fail_with(/expected given block not to yield with no arguments, but did/)
    end
  end

  describe "expect {...}.to yield_with_args" do
    it 'passes if the block yields with arguments' do
      expect { |b| _yield_with_args(1, &b) }.to yield_with_args
    end

    it 'fails if the block does not yield' do
      expect {
        expect { |b| _dont_yield(&b) }.to yield_with_args
      }.to fail_with(/expected given block to yield with arguments, but did not yield/)
    end

    it 'fails if the block yields with no arguments' do
      expect {
        expect { |b| _yield_with_no_args(&b) }.to yield_with_args
      }.to fail_with(/expected given block to yield with arguments, but yielded with no arguments/)
    end
  end

  describe "expect {...}.not_to yield_with_args" do
    it 'fails if the block yields with arguments' do
      expect {
        expect { |b| _yield_with_args(1, &b) }.not_to yield_with_args
      }.to fail_with(/expected given block not to yield with arguments, but did/)
    end

    it 'passes if the block does not yield' do
      expect { |b| _dont_yield(&b) }.not_to yield_with_args
    end

    it 'passes if the block yields with no arguments' do
      expect { |b| _yield_with_no_args(&b) }.not_to yield_with_args
    end
  end

  describe "expect {...}.to yield_with_args(3, 17)" do
    it 'passes if the block yields with the given arguments' do
      expect { |b| _yield_with_args(3, 17, &b) }.to yield_with_args(3, 17)
    end

    it 'fails if the block does not yield' do
      expect {
        expect { |b| _dont_yield(&b) }.to yield_with_args(3, 17)
      }.to fail_with(/expected given block to yield with arguments, but did not yield/)
    end

    it 'fails if the block yields with no arguments' do
      expect {
        expect { |b| _yield_with_no_args(&b) }.to yield_with_args(3, 17)
      }.to fail_with(/expected given block to yield with arguments, but yielded with unexpected arguments/)
    end

    it 'fails if the block yields with different arguments' do
      expect {
        expect { |b| _yield_with_args("a", "b", &b) }.to yield_with_args("a", "c")
      }.to fail_with(/expected given block to yield with arguments, but yielded with unexpected arguments/)
    end
  end

  describe "expect {...}.not_to yield_with_args(3, 17)" do
    it 'passes if the block yields with different arguments' do
      expect { |b| _yield_with_args("a", "b", &b) }.not_to yield_with_args("a", "c")
    end

    it 'fails if the block yields with the given arguments' do
      pending "Not sure how to phrase this failure message yet"
      expect { |b| _yield_with_args("a", "b", &b) }.not_to yield_with_args("a", "b")
    end
  end

  describe "expect {...}.to yield_with_args(/reg/, /ex/)" do
    it "passes if the block yields strings matching the regexes" do
      expect { |b| _yield_with_args("regular", "expression", &b) }.to yield_with_args(/reg/, /ex/)
    end

    it "fails if the block yields strings that do not match the regexes" do
      expect {
        expect { |b| _yield_with_args("no", "match", &b) }.to yield_with_args(/reg/, /ex/)
      }.to fail_with(/expected given block to yield with arguments, but yielded with unexpected arguments/)
    end
  end

  describe "expect {...}.to yield_with_args(String, Fixnum)" do
    it "passes if the block yields objects of the given types" do
      expect { |b| _yield_with_args("string", 15, &b) }.to yield_with_args(String, Fixnum)
    end

    it "passes if the block yields the given types" do
      expect { |b| _yield_with_args(String, Fixnum, &b) }.to yield_with_args(String, Fixnum)
    end

    it "fails if the block yields objects of different types" do
      expect {
        expect { |b| _yield_with_args(15, "string", &b) }.to yield_with_args(String, Fixnum)
      }.to fail_with(/expected given block to yield with arguments, but yielded with unexpected arguments/)
    end
  end
end
