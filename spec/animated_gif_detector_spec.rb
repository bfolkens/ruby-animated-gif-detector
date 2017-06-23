require "spec_helper"

describe AnimatedGifDetector do
  it 'has a version number' do
    expect(AnimatedGifDetector::VERSION).not_to be nil
  end

  it { expect(AnimatedGifDetector.new(nil).send(:last_characters, 'test', 2)).to eql('st') }
  it { expect(AnimatedGifDetector.new(nil).send(:count_substring_matches, 'test and test and testy', 'test')).to eql(3) }

  let(:animated_file) { File.open(File.join(__dir__, 'files', 'animated.gif'), 'rb') }
  let(:fixed_file) { File.open(File.join(__dir__, 'files', 'fixed.gif'), 'rb') }

  context 'when supplied with an animated image' do
    let(:detector) { AnimatedGifDetector.new(animated_file, buffer_size: 24) }

    it 'detects animation' do
      expect(detector.animated?).to be true
    end

    it 'returns immediately after the first frame' do
      detector.animated?
      expect(detector.frames).to eql(2)
    end
  end

  context 'works over multiple calls' do
    let(:detector) { AnimatedGifDetector.new(animated_file, buffer_size: 24) }

    it 'memoizes the result of animated' do
      expect(detector.animated?).to be true
      expect(detector.animated?).to be true
    end

    it 'rewinds the file' do
      detector1 = AnimatedGifDetector.new(animated_file, buffer_size: 24)
      expect(detector1.animated?).to be true

      detector2 = AnimatedGifDetector.new(animated_file, buffer_size: 24)
      expect(detector2.animated?).to be true
    end
  end

  context 'when supplied with a fixed image' do
    let(:detector) { AnimatedGifDetector.new(fixed_file) }

    it 'detects no animation' do
      expect(detector.animated?).to be false
    end

    it 'determines frame count' do
      detector.animated?
      expect(detector.frames).to eql(1)
    end
  end

  context 'when terminate_after_first_frame option is false' do
    let(:detector) { AnimatedGifDetector.new(animated_file, terminate_after: false) }

    it 'detects animation' do
      expect(detector.animated?).to be true
    end

    it 'detects all frames' do
      detector.animated?
      expect(detector.frames).to eql(3)
    end
  end

  context 'when supplied with a non-gif image' do
    let(:detector) { AnimatedGifDetector.new(StringIO.new('bad-data')) }

    it { expect { detector.animated? }.to raise_error(AnimatedGifDetector::UnrecognizedFileFormatException) }
  end

  context 'when supplied with a corrupted GIF image' do
    let(:detector) { AnimatedGifDetector.new(StringIO.new('GIF89a then-bad-data')) }

    it { expect { detector.animated? }.to raise_error(AnimatedGifDetector::EOFWithoutFrameException) }
  end
end
