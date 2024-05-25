// pages/index.js
import Head from 'next/head';

export default function Home() {
    return (
        <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-b from-blue-900 to-blue-700 text-white">
            <Head>
                <title>Netlify Clone</title>
                <meta name="description" content="Netlify landing page clone" />
                <link rel="icon" href="/favicon.ico" />
            </Head>

            <main className="flex flex-col items-center justify-center flex-1 px-20 text-center">
                <h1 className="text-6xl font-bold">
                    Connect everything. <br />
                    Build anything.
                </h1>

                <p className="mt-6 text-xl">
                    Netlify is the essential platform for the delivery of <span className="text-orange-400">exceptional</span> and dynamic web experiences, without <span className="text-orange-400">limitations</span>.
                </p>

                <div className="mt-8">
                    <button className="bg-teal-500 hover:bg-teal-700 text-white font-bold py-2 px-4 rounded m-2">
                        Deploy to Netlify
                    </button>
                    <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded m-2">
                        Request demo
                    </button>
                </div>
            </main>

            <footer className="w-full h-24 flex items-center justify-center border-t">
                <p>Netlify Footer</p>
            </footer>
        </div>
    );
}
