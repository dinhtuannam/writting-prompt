const assert = require('assert');
const { renderMarkdownToHtml } = require('../app.js');

// heading + paragraph
{
  const input = '# Chương 1: Buổi Sáng Mưa\n\nTrời đổ mưa từ sáng sớm.';
  const result = renderMarkdownToHtml(input);
  assert.strictEqual(
    result,
    '<h1>Chương 1: Buổi Sáng Mưa</h1>\n<p>Trời đổ mưa từ sáng sớm.</p>'
  );
  console.log('PASS renderMarkdownToHtml: heading + paragraph');
}

// bold and italic
{
  const input = 'Cô ấy **mạnh mẽ** nhưng *cô đơn*.';
  const result = renderMarkdownToHtml(input);
  assert.strictEqual(result, '<p>Cô ấy <strong>mạnh mẽ</strong> nhưng <em>cô đơn</em>.</p>');
  console.log('PASS renderMarkdownToHtml: bold and italic');
}

// internal newline becomes <br> within a paragraph block
{
  const input = '— Anh đi đâu đấy?\n— Tôi không biết.';
  const result = renderMarkdownToHtml(input);
  assert.strictEqual(result, '<p>— Anh đi đâu đấy?<br>— Tôi không biết.</p>');
  console.log('PASS renderMarkdownToHtml: internal newline becomes <br>');
}

// HTML special characters are escaped
{
  const input = 'Cô nói "1 < 2 & 3 > 0".';
  const result = renderMarkdownToHtml(input);
  assert.strictEqual(result, '<p>Cô nói "1 &lt; 2 &amp; 3 &gt; 0".</p>');
  console.log('PASS renderMarkdownToHtml: escapes <, >, &');
}

// multiple blocks
{
  const input = '# Chương 2\n\nĐoạn một.\n\nĐoạn hai.';
  const result = renderMarkdownToHtml(input);
  assert.strictEqual(
    result,
    '<h1>Chương 2</h1>\n<p>Đoạn một.</p>\n<p>Đoạn hai.</p>'
  );
  console.log('PASS renderMarkdownToHtml: multiple paragraph blocks');
}

console.log('All markdown.test.js tests passed.');
