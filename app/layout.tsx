import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title: 'SuperFertility | Care pathway demo', description: 'Interactive demonstration of the SuperFertility Standard private-consult pathway.' };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="en-AU"><body>{children}</body></html>; }
