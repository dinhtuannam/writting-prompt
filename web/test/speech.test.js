const assert = require('assert');
const { splitForSpeech } = require('../app.js');

// short paragraph stays whole, whitespace collapsed
{
  const result = splitForSpeech('— Anh đi đâu đấy?\n— Tôi không biết.', 220);
  assert.deepStrictEqual(result, ['— Anh đi đâu đấy? — Tôi không biết.']);
  console.log('PASS splitForSpeech: short paragraph stays whole');
}

// empty text gives no chunks
{
  assert.deepStrictEqual(splitForSpeech('   \n ', 220), []);
  console.log('PASS splitForSpeech: empty text');
}

// long paragraph splits at sentence ends and keeps every word
{
  const input = 'Sương bạc phủ mặt sông. Quạ kêu trên cây cháy! Cán giáo gõ vào nhau… Ai đó ho.';
  const result = splitForSpeech(input, 50);
  assert.deepStrictEqual(result, ['Sương bạc phủ mặt sông. Quạ kêu trên cây cháy!', 'Cán giáo gõ vào nhau… Ai đó ho.']);
  result.forEach((chunk) => assert.ok(chunk.length <= 50));
  console.log('PASS splitForSpeech: splits at sentence ends');
}

// sentence longer than limit splits at commas, then words
{
  const input = 'Hennes đếm cọc, đếm người, đếm từng tiếng ho trong sương sớm của bến lội Haselfurt lạnh ngắt';
  const result = splitForSpeech(input, 30);
  result.forEach((chunk) => assert.ok(chunk.length <= 30, chunk));
  assert.strictEqual(result.join(' '), input);
  assert.strictEqual(result[0], 'Hennes đếm cọc, đếm người,');
  console.log('PASS splitForSpeech: long sentence splits at commas then words');
}
