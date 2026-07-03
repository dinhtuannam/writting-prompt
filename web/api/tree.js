// Vercel serverless function — proxy gọi GitHub API bằng token phía server.
// Lý do: gọi api.github.com trực tiếp từ trình duyệt bị giới hạn 60 request/giờ
// theo IP; điện thoại dùng mạng di động (CGNAT dùng chung IP) dễ bị 403 vì
// hết quota do người khác trên cùng IP. Proxy này dùng GITHUB_TOKEN (5000
// request/giờ) và chạy trên hạ tầng Vercel nên không còn phụ thuộc IP người xem.
const GITHUB_OWNER = 'dinhtuannam';
const GITHUB_REPO = 'writting-prompt';
const GITHUB_BRANCH = 'main';

module.exports = async (req, res) => {
  const headers = {
    'User-Agent': 'writting-prompt-web',
    Accept: 'application/vnd.github+json',
  };
  if (process.env.GITHUB_TOKEN) {
    headers.Authorization = `Bearer ${process.env.GITHUB_TOKEN}`;
  }

  try {
    const ghRes = await fetch(
      `https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/git/trees/${GITHUB_BRANCH}?recursive=1`,
      { headers }
    );
    const data = await ghRes.json();
    res.setHeader('Cache-Control', 'public, max-age=0, s-maxage=60, stale-while-revalidate=300');
    res.status(ghRes.status).json(data);
  } catch (err) {
    res.status(502).json({ message: 'Không kết nối được tới GitHub.' });
  }
};
